import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/core/remote_service/api_failure.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/repository/i_survey_repository.dart';


@injectable
class GetFormFieldUseCase {
  final ISurveyRepository _iSurveyRepository;

  const GetFormFieldUseCase(this._iSurveyRepository);

  Future<Either<Failure, GetSurveyFormFieldEntity>> call() async {
    return await _iSurveyRepository.getSurveyFormField();
  }
}
