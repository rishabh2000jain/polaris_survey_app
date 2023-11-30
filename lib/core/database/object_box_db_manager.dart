import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:polaris_survey_app/constants.dart';
import 'package:polaris_survey_app/core/database/database_manager.dart';
import 'package:polaris_survey_app/objectbox.g.dart';
import 'package:path/path.dart' as path;


///[ObjectBoxDbManager] is responsible for initializing database object,
///disposing it and providing database instance.

@Singleton(as: IDatabaseManager<Store>)
class ObjectBoxDbManager extends IDatabaseManager<Store>{
  Store? _store;
  @override
  Store get() {
    if(_store == null){
      throw Exception('Database not initialized');
    }
    return _store!;
  }

  @override
  Future<void> init() async{
    if(_store!=null) return;
    final dir = await path_provider.getApplicationDocumentsDirectory();
    _store = await openStore(directory: path.join(dir.path,AppConstants.surveyDb));
  }

  @override
  @disposeMethod
  void dispose(){
    _store?.close();
    _store = null;
  }

}