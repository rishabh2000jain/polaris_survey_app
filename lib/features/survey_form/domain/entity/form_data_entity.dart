import 'dart:io';

class FieldData {
  final String id;
  final String label;
  dynamic value;
  List<File>? files;
  bool isValid;
  String? bucketPath;


  FieldData({
    required this.id,
    required this.label,
    required this.isValid,
    this.bucketPath,
    this.files,
    this.value,
  });
}


