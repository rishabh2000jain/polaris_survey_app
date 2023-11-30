class SurveyFormFieldModel {
  String? formName;
  List<Fields>? fields;

  SurveyFormFieldModel({this.formName, this.fields});

  SurveyFormFieldModel.fromJson(Map<String, dynamic> json) {
    formName = json['form_name'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['form_name'] = formName;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  MetaInfo? metaInfo;
  String? componentType;

  Fields({this.metaInfo, this.componentType});

  Fields.fromJson(Map<String, dynamic> json) {
    metaInfo = json['meta_info'] != null
        ?   MetaInfo.fromJson(json['meta_info'])
        : null;
    componentType = json['component_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    if (metaInfo != null) {
      data['meta_info'] = metaInfo!.toJson();
    }
    data['component_type'] = componentType;
    return data;
  }
}

class MetaInfo {
  String? label;
  String? componentInputType;
  String? mandatory;
  List<String>? options;
  int? noOfImagesToCapture;
  String? savingFolder;

  MetaInfo(
      {this.label,
        this.componentInputType,
        this.mandatory,
        this.options,
        this.noOfImagesToCapture,
        this.savingFolder});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    componentInputType = json['component_input_type'];
    mandatory = json['mandatory'];
    options = json['options']?.cast<String>();
    noOfImagesToCapture = json['no_of_images_to_capture'];
    savingFolder = json['saving_folder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =   <String, dynamic>{};
    data['label'] = label;
    data['component_input_type'] = componentInputType;
    data['mandatory'] = mandatory;
    data['options'] = options;
    data['no_of_images_to_capture'] = noOfImagesToCapture;
    data['saving_folder'] = savingFolder;
    return data;
  }
}
