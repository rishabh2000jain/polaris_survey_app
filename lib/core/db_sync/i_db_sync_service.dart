import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:polaris_survey_app/core/app_state.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/event_bus_manager.dart';

abstract class IDbSyncService{
   IDbSyncService(SyncType syncType,Duration? duration){
     assert((){
       return (syncType == SyncType.periodic ||syncType == SyncType.networkStateChangesAndPeriodic) && duration!=null;
     }());
     switch(syncType){
       case SyncType.networkStateChanges:{
         _listenNetworkUpdates();
         break;
       }
       case SyncType.periodic:{
         _syncPeriodic(duration!);
         break;
       }
       case SyncType.networkStateChangesAndPeriodic:{
         _listenNetworkUpdates();
         _syncPeriodic(duration!);
         break;
       }
       case SyncType.none:
     }
  }


  Timer? _timer;

  bool _syncRunning = false;

  bool get syncRunning => _syncRunning;

  void _listenNetworkUpdates(){
    debugPrint('Started Network State Change Sync Service');
    getIt<EventBusManager>().networkEvents.listen((event) {
      if(event.connected){
        _mayBeStartSync();
      }else if(_syncRunning){
        stopSync();
      }
    });
  }

  void _syncPeriodic(Duration duration){
    debugPrint('Started Periodic Sync Service');
    _timer = Timer.periodic(duration, (timer) {
      _mayBeStartSync();
    });
  }

  void _mayBeStartSync(){
    if(AppState.instance.connectedToInternet && !_syncRunning) {
      startSync();
    }
  }


  Future<void> startSync()async{
    _syncRunning=true;
    debugPrint('Sync Started');
  }
  Future<void> stopSync()async{
    _syncRunning=false;
    debugPrint('Sync Ended');
  }
  void dispose(){
    _timer?.cancel();
    _timer = null;
  }
}

enum SyncType{
  periodic,
  networkStateChanges,
  networkStateChangesAndPeriodic,
  none
}