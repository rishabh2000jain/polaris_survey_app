enum WidgetTypeEnum {
  editText('EditText'),
  checkBoxes('CheckBoxes'),
  dropDown('DropDown'),
  captureImages('CaptureImages'),
  radioGroup('RadioGroup'),
  none('None');

  const WidgetTypeEnum(this.componentName);

  final String componentName;

  static WidgetTypeEnum fromComponentName(String? name) {
    return WidgetTypeEnum.values.firstWhere(
      (element) => element.componentName == name,
      orElse: () => WidgetTypeEnum.none,
    );
  }
}
