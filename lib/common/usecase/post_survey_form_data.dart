import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/models/survey_form_model.dart';
import 'package:polaris_survey_app/core/remote_service/api_failure.dart';
import 'package:polaris_survey_app/core/remote_service/api_success.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/form_data_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/repository/i_survey_repository.dart';


@injectable
class PostSurveyFormDataUseCase {
  final ISurveyRepository _iSurveyRepository;

  const PostSurveyFormDataUseCase(this._iSurveyRepository);

  Future<Either<Failure, Success>> toServer(SurveyFormModel model) async {
    List<Map<String,dynamic>> formFields = [];
    for (var element in model.formField) {
      formFields.add({
        'label':element.label,
        'value':(){
          if(element.value!=null){
            return jsonDecode(element.value!);
          }
          return element.images.map((element) => element.publicHttpUrl).toList();
        }(),
      });
    }
    return await _iSurveyRepository.postSurveyFormData(formFields,false);
  }

  Future<Either<Failure, Success>> call(List<FieldData> formData) async {
    return await _iSurveyRepository.postSurveyFormData(formData,true);
  }



}
