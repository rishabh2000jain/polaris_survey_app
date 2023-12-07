import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/database/database_service.dart';
import 'package:polaris_survey_app/core/database/exceptions.dart';
import 'package:polaris_survey_app/core/db_models/survey_form_fields_model.dart';

@singleton
class SurveyFormFieldsDb extends IDatabaseService<SurveyFormFieldsDbModel>
    with
        Update<SurveyFormFieldsDbModel>,
        Read<SurveyFormFieldsDbModel>,
        ReadAll<SurveyFormFieldsDbModel>,
        DeleteAll<SurveyFormFieldsDbModel> {
  SurveyFormFieldsDb(super.manager);

  @override
  Future<SurveyFormFieldsDbModel> read(int id) async {
    final model =
        await manager.get().box<SurveyFormFieldsDbModel>().getAsync(id);
    if (model == null) {
      throw EntryNotFoundException(id);
    }
    return model;
  }

  @override
  Future<List<SurveyFormFieldsDbModel>> readAll() async {
    return await manager.get().box<SurveyFormFieldsDbModel>().getAllAsync();
  }

  @override
  Future<SurveyFormFieldsDbModel> update(SurveyFormFieldsDbModel data) async {
    await deleteAll();
    final id =
        await manager.get().box<SurveyFormFieldsDbModel>().putAsync(data);
    return read(id);
  }

  @override
  Future<bool> deleteAll() async {
    return (await manager
            .get()
            .box<SurveyFormFieldsDbModel>()
            .removeAllAsync()) >
        0;
  }
}
