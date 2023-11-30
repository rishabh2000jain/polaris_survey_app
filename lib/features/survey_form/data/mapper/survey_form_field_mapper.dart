import 'package:polaris_survey_app/core/enums/widget_type_enum.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';
import 'package:polaris_survey_app/features/survey_form/data/model/survey_form_field_model.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';

class SurveyFormFieldMapper {
  GetSurveyFormFieldEntity call(SurveyFormFieldModel model) {
    return GetSurveyFormFieldEntity(
      formTitle: model.formName ?? '',
      widgetModels: (model.fields
              ?.map(
                (e) => WidgetModel(
                  'widget_id_${e.metaInfo?.label??''}_${DateTime.now().microsecondsSinceEpoch}',
                  WidgetTypeEnum.fromComponentName(e.componentType),
                  WidgetProperties.fromJson(
                    WidgetTypeEnum.fromComponentName(e.componentType),
                    e.metaInfo?.toJson() ?? {},
                  ),
                ),
              )
              .toList()) ??
          [],
    );
  }
}
