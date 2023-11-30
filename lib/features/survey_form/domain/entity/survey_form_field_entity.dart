import 'package:polaris_survey_app/core/models/widget_model.dart';

class GetSurveyFormFieldEntity{
  final String formTitle;
  final List<WidgetModel> widgetModels;
  const GetSurveyFormFieldEntity({required this.formTitle,required this.widgetModels});
}