class AppState {
  static AppState? _instance;

  AppState._();

  static AppState get instance {
    _instance ??= AppState._();
    return _instance!;
  }

  bool _connectedToInternet = true;

  bool get connectedToInternet => _connectedToInternet;

  set connectedToInternet(val) {
    _connectedToInternet = val;
  }
}
