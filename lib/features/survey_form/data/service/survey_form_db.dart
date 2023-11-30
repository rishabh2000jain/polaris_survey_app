import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/database/database_service.dart';
import 'package:polaris_survey_app/core/database/exceptions.dart';
import 'package:polaris_survey_app/core/models/survey_form_model.dart';

@singleton
class SurveyFormDbService extends IDatabaseService<SurveyFormModel>{
  SurveyFormDbService(super.manager);

  @override
  Future<SurveyFormModel> create(SurveyFormModel data) async{
   final id = await manager.get().box<SurveyFormModel>().putAsync(data);
    return read(id);
  }

  @override
  Future<bool> delete(int id)async {
    return manager.get().box<SurveyFormModel>().removeAsync(id);
  }

  @override
  Future<SurveyFormModel> read(int id) async{
    final model =  await manager.get().box<SurveyFormModel>().getAsync(id);
    if(model==null){
      throw EntryNotFoundException(id);
    }
    return model;
  }

  @override
  Future<List<SurveyFormModel>> readAll() async{
    return manager.get().box<SurveyFormModel>().getAllAsync();
  }

  @override
  Future<SurveyFormModel> update(SurveyFormModel data)async {
    final model =  await create(data);
    return model;
  }

  Future<int> updateImage(Image image,)async{
   return await manager.get().box<Image>().putAsync(image);
  }
  Future<bool> removeImage(int imageId,)async{
   return await manager.get().box<Image>().removeAsync(imageId);
  }

}