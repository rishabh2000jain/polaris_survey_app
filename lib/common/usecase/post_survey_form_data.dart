import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/models/survey_form_model.dart';
import 'package:polaris_survey_app/core/remote_service/api_failure.dart';
import 'package:polaris_survey_app/core/remote_service/api_success.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/form_data_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/repository/i_survey_repository.dart';

///[PostSurveyFormDataUseCase] Use Case is responsible
///to insert the data into database and upload that to server.

@injectable
class PostSurveyFormDataUseCase {
  final ISurveyRepository _iSurveyRepository;

  const PostSurveyFormDataUseCase(this._iSurveyRepository);

  ///[toServer] will upload the form response to the server
  ///and it should be used only when all the necessary files has been uploaded
  ///to cloud storage and the url associated with them are provided.
  Future<Either<Failure, Success>> toServer(SurveyFormModel model) async {
    List<Map<String, dynamic>> formFields = [];
    for (var element in model.formField) {
      formFields.add({
        'label': element.label,
        'value': () {
          if (element.value != null) {
            return jsonDecode(element.value!);
          } else if (element.images.isNotEmpty) {
            return element.images
                .map((element) => element.publicHttpUrl)
                .toList();
          }
          return null;
        }(),
      });
    }
    return await _iSurveyRepository.saveSurveyFormData(formFields, false);
  }


  ///[call] method will fill the data into the database and
  ///then start the synchronization process
  ///to upload data to server in background.
  Future<Either<Failure, Success>> call(List<FieldData> formData) async {
    return await _iSurveyRepository.saveSurveyFormData(formData, true);
  }
}
