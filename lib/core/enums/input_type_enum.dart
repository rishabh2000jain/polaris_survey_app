enum WidgetInputType {
  integer("INTEGER"),
  text("TEXT");

  const WidgetInputType(this.typeName);

  final String typeName;

  static WidgetInputType fromName(String name) {
    return WidgetInputType.values.firstWhere(
          (element) => element.typeName == name,
      orElse: () => WidgetInputType.text,
    );
  }
}
