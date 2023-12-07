import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_survey_app/common/widgets/capture_image_group.dart';
import 'package:polaris_survey_app/common/widgets/check_box_group.dart';
import 'package:polaris_survey_app/common/widgets/drop_down.dart';
import 'package:polaris_survey_app/common/widgets/edit_text.dart';
import 'package:polaris_survey_app/common/widgets/radio_group.dart';
import 'package:polaris_survey_app/common/widgets/solid_button.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/enums/widget_type_enum.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';
import 'package:polaris_survey_app/features/survey_form/presentation/bloc/fill_survey_cubit.dart';
import 'package:polaris_survey_app/features/survey_form/presentation/bloc/survey_states.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  late FillSurveyCubit _fillSurveyCubit;

  @override
  void initState() {
    _fillSurveyCubit = getIt<FillSurveyCubit>();
    _fillSurveyCubit.loadSurveyForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<FillSurveyCubit, SurveyStates>(
          listener: (context, state) {
            if (state is SurveyFormIncomplete) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Field ${state.incompleteLabel} is not complete',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                      fontSize: 16),
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: Theme.of(context).colorScheme.error,
              ));
            } else if (state is SurveyFormSavedState) {
              if (state.saved) {
                _fillSurveyCubit.loadSurveyForm();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Form added successfully',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 16),
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Oops! Failed to save form',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 16),
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
            }
          },
          bloc: _fillSurveyCubit,
          buildWhen: (prev, curr) {
            return curr is LoadingSurveyForm ||
                curr is ErrorLoadingSurveyForm ||
                curr is SurveyFormLoaded;
          },
          builder: (context, state) {
            if (state is LoadingSurveyForm) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ErrorLoadingSurveyForm) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                        onPressed: () {
                          _fillSurveyCubit.loadSurveyForm();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('oops! click to refresh'))
                  ],
                ),
              );
            } else if (state is SurveyFormLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        state.surveyFormFieldEntity.formTitle,
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _fillSurveyCubit.loadSurveyForm(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...state.surveyFormFieldEntity.widgetModels
                                  .map(
                                    (e) => () {
                                      return Stack(
                                        children: [
                                          Container(
                                            key: Key(e.id),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
                                                      spreadRadius: 0,
                                                      blurRadius: 5)
                                                ]),
                                            padding: const EdgeInsets.all(12),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 24),
                                            child: () {
                                              return switch (e.widgetTypeEnum) {
                                                WidgetTypeEnum.editText =>
                                                  CommonTextFormField(
                                                    key: ObjectKey(e.id),
                                                    properties: e.properties
                                                        as EditTextProperties,
                                                    onChange: (value) {
                                                      _fillSurveyCubit
                                                          .updateValue(
                                                              e.id, value);
                                                    },
                                                  ),
                                                WidgetTypeEnum.checkBoxes =>
                                                  CheckBoxGroup(
                                                    key: ObjectKey(e.id),
                                                    onUpdate: (List<String>
                                                        selectedOptions) {
                                                      _fillSurveyCubit
                                                          .updateValue(e.id,
                                                              selectedOptions);
                                                    },
                                                    properties: e.properties
                                                        as CheckBoxProperties,
                                                  ),
                                                WidgetTypeEnum.dropDown =>
                                                  CustomDropdown(
                                                    key: ObjectKey(e.id),
                                                    properties: e.properties
                                                        as DropDownProperties,
                                                    onSelect: (value) {
                                                      _fillSurveyCubit
                                                          .updateValue(
                                                              e.id, value);
                                                    },
                                                  ),
                                                WidgetTypeEnum.radioGroup =>
                                                  RadioButtonGroup(
                                                    key: ObjectKey(e.id),
                                                    properties: e.properties
                                                        as RadioGroupProperties,
                                                    onChanged: (String value) {
                                                      _fillSurveyCubit
                                                          .updateValue(
                                                              e.id, value);
                                                    },
                                                  ),
                                                WidgetTypeEnum.captureImages =>
                                                  CaptureImageList(
                                                    key: ObjectKey(e.id),
                                                    filesUpdated:
                                                        (List<File> files) {
                                                      _fillSurveyCubit
                                                          .updateValue(
                                                              e.id, files);
                                                    },
                                                    properties: (e.properties
                                                        as CaptureImageProperties),
                                                  ),
                                                WidgetTypeEnum.none =>
                                                  const SizedBox.shrink(),
                                              };
                                            }(),
                                          ),
                                          if (e.properties.mandatory)
                                            Positioned(
                                                left: 29,
                                                top: 4,
                                                child: Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                      fontSize: 20),
                                                ))
                                        ],
                                      );
                                    }(),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SolidButtonWidget(
                        onPressed: () async {
                          await _fillSurveyCubit.mayBeUploadForm();
                        },
                        text: 'Save',
                        height: 48,
                        width: double.maxFinite,
                      ),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
