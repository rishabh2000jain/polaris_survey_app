abstract class IDatabaseManager<T>{
  Future<void> init();
  T get();
  void dispose();
}