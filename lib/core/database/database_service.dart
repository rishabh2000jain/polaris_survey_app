import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';
import 'package:polaris_survey_app/core/database/database_manager.dart';

abstract class IDatabaseService<T> {

  @protected
  IDatabaseManager<Store> manager;

  IDatabaseService(this.manager);

  Future<T> create(T data);

  Future<bool> delete(int id);

  Future<T> update(T data);

  Future<T> read(int id);

  Future<List<T>> readAll();
}
