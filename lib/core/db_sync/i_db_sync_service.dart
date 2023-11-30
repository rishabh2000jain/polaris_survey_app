import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:polaris_survey_app/core/app_state.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/event_bus_manager.dart';

abstract class IDbSyncService {
  IDbSyncService(SyncType syncType, Duration? duration) {
    assert(() {
      return (syncType == SyncType.periodic ||
              syncType == SyncType.networkAvailableAndPeriodic) &&
          duration != null;
    }());
    switch (syncType) {
      case SyncType.networkAvailable:
        {
          _listenNetworkUpdates();
          break;
        }
      case SyncType.periodic:
        {
          _syncPeriodic(duration!);
          break;
        }
      case SyncType.networkAvailableAndPeriodic:
        {
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

  void _listenNetworkUpdates() {
    debugPrint('Started Network State Change Sync Service');
    getIt<EventBusManager>().networkEvents.listen((event) {
      if (event.connected) {
        _mayBeStartSync();
      } else if (_syncRunning) {
        stopSync();
      }
    });
  }

  void _syncPeriodic(Duration duration) {
    debugPrint('Started Periodic Sync Service');
    _timer = Timer.periodic(duration, (timer) {
      _mayBeStartSync();
    });
  }

  void _mayBeStartSync() {
    if (AppState.instance.connectedToInternet && !_syncRunning) {
      startSync();
    }
  }

  Future<void> startSync() async {
    _syncRunning = true;
    debugPrint('Sync Started');
  }

  Future<void> stopSync() async {
    _syncRunning = false;
    debugPrint('Sync Ended');
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

///[SyncType] states the methods which will be used to sync
///data in background.

enum SyncType {
  ///[SyncType.periodic] will start the synchronization
  ///process in time difference provided.
  periodic,

  ///[SyncType.networkAvailable] will start the sync only when
  ///the device gets connected to a network.
  networkAvailable,

  ///[SyncType.networkAvailableAndPeriodic] will sync the data by following [SyncType.networkAvailable] and [SyncType.periodic].
  networkAvailableAndPeriodic,

  ///If you require to start the sync process only by invoking an event use this.
  none
}
