import 'package:either_dart/either.dart';
import 'package:polaris_survey_app/core/remote_service/api_failure.dart';
import 'package:polaris_survey_app/core/remote_service/api_success.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';

abstract class ISurveyRepository{
  Future<Either<Failure,GetSurveyFormFieldEntity>> getSurveyFormField();
  Future<Either<Failure,Success>> postSurveyFormData(List data,bool insertToDbFirst);
}