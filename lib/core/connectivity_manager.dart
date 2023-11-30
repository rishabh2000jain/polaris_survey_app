import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/app_state.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/event_bus_manager.dart';

@singleton
class ConnectivityManager {
  Connectivity? _connectivity;
  StreamSubscription<ConnectivityResult>? _networkStreamSubscription;
  Future<void> init() async{
    if (_connectivity == null) {
      _connectivity = Connectivity();
      _networkStreamSubscription = _connectivity!.onConnectivityChanged.listen((ConnectivityResult event) async{
        if(event == ConnectivityResult.wifi || event == ConnectivityResult.mobile){
          final result = await _confirmConnected();
          _connectivityAppState(result);
        }else{
          _connectivityAppState(false);
        }
      });
    }
  }

  void _connectivityAppState(bool state){
    if(state == AppState.instance.connectedToInternet){
      return;
    }
    AppState.instance.connectedToInternet = state;
    getIt<EventBusManager>().fireNetworkConnectionUpdate(state);
  }

  Future<bool> _confirmConnected()async{
    try {
      List<InternetAddress> addresses = await InternetAddress.lookup('www.google.com').timeout(const Duration(seconds: 5));
      return addresses.isNotEmpty && addresses.first.rawAddress.isNotEmpty;
    }catch(exception){
      return false;
    }
  }

  @disposeMethod
  void dispose(){
    _networkStreamSubscription?.cancel();
  }

}