import 'package:polaris_survey_app/core/enums/input_type_enum.dart';
import 'package:polaris_survey_app/core/enums/widget_type_enum.dart';

class WidgetModel {
  final String id;
  final WidgetTypeEnum widgetTypeEnum;
  final WidgetProperties properties;

  const WidgetModel(this.id,this.widgetTypeEnum, this.properties);
}

class Option {
  final String name;
  Option(this.name,);
}

abstract class WidgetProperties {
  late String label;
  late bool mandatory;

  WidgetProperties();

  factory WidgetProperties.fromJson(WidgetTypeEnum widgetTypeEnum,Map<String,dynamic> json){
    return switch (widgetTypeEnum) {
    WidgetTypeEnum.captureImages =>CaptureImageProperties(mandatory: json['mandatory']=='yes',label: json['label'], numberOfFiles: json['no_of_images_to_capture'], savingFolder: json['saving_folder']),
    WidgetTypeEnum.dropDown=>DropDownProperties(mandatory: json['mandatory']=='yes',label: json['label'],options: (json['options'] as List<String>).map((e) => Option(e)).toList()),
    WidgetTypeEnum.radioGroup=>RadioGroupProperties(mandatory: json['mandatory']=='yes',options: (json['options'] as List<String>).map((e) => Option(e)).toList(),label: json['label']),
    WidgetTypeEnum.checkBoxes=>CheckBoxProperties(mandatory: json['mandatory']=='yes',options: (json['options'] as List<String>).map((e) => Option(e)).toList(),label: json['label']),
    WidgetTypeEnum.editText=> EditTextProperties(mandatory: json['mandatory']=='yes',inputType: WidgetInputType.fromName(json['component_input_type']),label: json['label']),
    WidgetTypeEnum.none=> throw UnimplementedError('Unknown Widget type found'),
  };
  }
}

abstract class MultiOptionWidgetProperties extends WidgetProperties {
  late List<Option> options;
}

abstract class FileInputWidgetProperties extends WidgetProperties {
  late int numberOfFiles;
  late String savingFolder;
}

class EditTextProperties implements WidgetProperties {
  @override
  String label;
  @override
  bool mandatory;

  WidgetInputType inputType;

  EditTextProperties({
    required this.label,
    required this.mandatory,
    required this.inputType,
  });
}

class CheckBoxProperties implements MultiOptionWidgetProperties {
  @override
  String label;

  @override
  bool mandatory;

  @override
  List<Option> options;

  CheckBoxProperties({
    required this.label,
    required this.mandatory,
    required this.options,
  });
}

class DropDownProperties implements MultiOptionWidgetProperties {
  @override
  String label;

  @override
  bool mandatory;

  @override
  List<Option> options;

  DropDownProperties({
    required this.label,
    required this.mandatory,
    required this.options,
  });
}

class RadioGroupProperties implements MultiOptionWidgetProperties {
  @override
  String label;

  @override
  bool mandatory;

  @override
  List<Option> options;

  RadioGroupProperties({
    required this.label,
    required this.mandatory,
    required this.options,
  });
}

class CaptureImageProperties implements FileInputWidgetProperties {
  @override
  String label;

  @override
  bool mandatory;

  @override
  int numberOfFiles;

  @override
  String savingFolder;

  CaptureImageProperties({
    required this.mandatory,
    required this.label,
    required this.numberOfFiles,
    required this.savingFolder,
  });
}
