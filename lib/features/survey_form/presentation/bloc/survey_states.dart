import 'package:equatable/equatable.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/form_data_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';

abstract class SurveyStates extends Equatable {
  const SurveyStates();
  @override
  List<Object?> get props => [];
}
class LoadingSurveyForm extends SurveyStates {}
class ErrorLoadingSurveyForm extends SurveyStates {}
class SurveyFormLoaded extends SurveyStates {
  final GetSurveyFormFieldEntity surveyFormFieldEntity;
  final List<FieldData> formData;
  const SurveyFormLoaded(this.surveyFormFieldEntity,this.formData);
  @override
  List<Object?> get props => [formData];
}
class SurveyFormSavedState extends SurveyStates {
  const SurveyFormSavedState(this.saved);
  final bool saved;
}
class SurveyFormIncomplete extends SurveyStates {
  final String incompleteLabel;
  final int id;
  const SurveyFormIncomplete(this.incompleteLabel,this.id);
  @override
  List<Object?> get props => [incompleteLabel,id];
}
class SurveyFormComplete extends SurveyStates {
  const SurveyFormComplete();
}
