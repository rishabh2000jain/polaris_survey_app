import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';
import 'package:polaris_survey_app/core/database/database_manager.dart';

abstract class IDatabaseService<T> {
  @protected
  IDatabaseManager<Store> manager;

  IDatabaseService(this.manager);
}

mixin Create<T> on IDatabaseService<T> {
  Future<T> create(T data);
}
mixin Delete<T> on IDatabaseService<T> {
  Future<bool> delete(int id);
}

mixin Update<T> on IDatabaseService<T> {
  Future<T> update(T data);
}
mixin Read<T> on IDatabaseService<T> {
  Future<T> read(int id);
}
mixin ReadAll<T> on IDatabaseService<T> {
  Future<List<T>> readAll();
}

mixin DeleteAll<T> on IDatabaseService<T> {
  Future<bool> deleteAll();
}
