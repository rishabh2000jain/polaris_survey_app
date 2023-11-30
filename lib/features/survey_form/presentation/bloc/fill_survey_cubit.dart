import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/common/usecase/post_survey_form_data.dart';
import 'package:polaris_survey_app/core/enums/widget_type_enum.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/form_data_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/usecase/get_form_field_usecase.dart';
import 'package:polaris_survey_app/features/survey_form/presentation/bloc/survey_states.dart';

@injectable
class FillSurveyCubit extends Cubit<SurveyStates> {
  FillSurveyCubit(this._formFieldUseCase, this._postSurveyFormDataUseCase)
      : super(LoadingSurveyForm());
  final GetFormFieldUseCase _formFieldUseCase;
  final PostSurveyFormDataUseCase _postSurveyFormDataUseCase;
  GetSurveyFormFieldEntity? formFieldEntity;
  final List<FieldData> _formData = [];

  ///[loadSurveyForm] will get the form fields and emit [SurveyFormLoaded] or [ErrorLoadingSurveyForm].
  Future<void> loadSurveyForm() async {
    emit(LoadingSurveyForm());

    void refreshUserData(List<WidgetModel> models) {
      _formData.clear();
      for (var element in models) {
        _formData.add(
          FieldData(
            label: element.properties.label,
            files: null,
            id: element.id,
            value: null,
            isValid: !element.properties.mandatory,
            bucketPath: (element.widgetTypeEnum == WidgetTypeEnum.captureImages
                ? (element.properties as CaptureImageProperties).savingFolder
                : null),
          ),
        );
      }
    }

    final response = await _formFieldUseCase.call();
    response.fold(
      (left) => emit(ErrorLoadingSurveyForm()),
      (right) {
        formFieldEntity = right;
        refreshUserData(formFieldEntity!.widgetModels);
        emit(SurveyFormLoaded(right, _formData));
      },
    );
  }

  ///[updateValue] should be used to update the value of any form field
  ///by providing [widgetId] of that specific field or widget.
  void updateValue(String widgetId, dynamic value) {
    if (formFieldEntity == null) return;
    int formWidgetIndex =
        _formData.indexWhere((element) => element.id == widgetId);
    final widgetFormData = _formData[formWidgetIndex];
    final widgetData = formFieldEntity!.widgetModels
        .firstWhere((element) => element.id == widgetId);

    widgetFormData.value = null;
    widgetFormData.files = null;

    if (widgetData.widgetTypeEnum == WidgetTypeEnum.captureImages) {
      widgetFormData.files = value;
    } else if (value is List && value.isEmpty) {
      widgetFormData.value = null;
    } else {
      widgetFormData.value = value;
    }

    if (widgetData.widgetTypeEnum == WidgetTypeEnum.captureImages) {
      widgetFormData.isValid = !widgetData.properties.mandatory ||
          (widgetFormData.files != null &&
              (widgetData.properties as CaptureImageProperties).numberOfFiles ==
                  widgetFormData.files!.length);
    } else {
      widgetFormData.isValid =
          !widgetData.properties.mandatory || widgetFormData.value != null;
    }
    _formData[formWidgetIndex] = widgetFormData;
    emit(SurveyFormLoaded(formFieldEntity!, _formData));
  }

  ///[_checkFormCompletion] will check weather the form is
  ///complete or not and satisfy all the necessary conditions,
  ///if not then it will emit [SurveyFormIncomplete] with the label of that
  ///form field.
  bool _checkFormCompletion() {
    for (var element in _formData) {
      if (!element.isValid) {
        emit(
          SurveyFormIncomplete(
              element.label, DateTime.now().microsecondsSinceEpoch),
        );
        return false;
      }
    }
    return true;
  }

  ///[mayBeUploadForm] can be used to upload the form.
  ///This method will take care of validating the form.
  Future<void> mayBeUploadForm() async {
    if (!_checkFormCompletion()) {
      return;
    }
    final response = await _postSurveyFormDataUseCase.call(_formData);
    response.fold((left) {
      emit(
        const SurveyFormSavedState(false),
      );
    }, (right) {
      emit(
        const SurveyFormSavedState(true),
      );
    });
  }
}
