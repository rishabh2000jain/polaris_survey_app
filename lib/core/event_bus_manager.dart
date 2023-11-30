import 'package:equatable/equatable.dart';
import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';

@singleton
class EventBusManager {
  final EventBus _eventBus = EventBus();


  Stream<NetworkStateChangeEvent> get networkEvents => _eventBus.on<NetworkStateChangeEvent>();

  Stream<StartSurveyFormSync> get surveyFormSyncEvents => _eventBus.on<StartSurveyFormSync>();

  void fireNetworkConnectionUpdate(bool connected) {
    _eventBus.fire(NetworkStateChangeEvent(connected));
  }

  void startSurveyFormSync() {
    _eventBus.fire(const StartSurveyFormSync());
  }

  @disposeMethod
  void destroy(){
    _eventBus.destroy();
  }
}

class NetworkStateChangeEvent extends Equatable {
  final bool connected;

  const NetworkStateChangeEvent(this.connected);

  @override
  List<Object?> get props => [connected];
}

class StartSurveyFormSync extends Equatable {

  const StartSurveyFormSync();

  @override
  List<Object?> get props => [];
}
