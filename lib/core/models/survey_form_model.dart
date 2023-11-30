import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SurveyFormModel {
  @Id()
  int id = 0;

  final formField = ToMany<FormField>();
  
  bool readyToDelete(){
    return formField.every((element) => element.allImagesUploaded());
  }
}

@Entity()
class FormField {
  @Id()
  int id = 0;

  String label;

  String? value;

  final images = ToMany<Image>();

  FormField({this.id = 0, required this.label,this.value});
  
  bool allImagesUploaded(){
    return images.every((element) => element.uploaded);
  }
}

@Entity()
class Image {
  @Id()
  int id = 0;

  ///binary large object
  @Property(type: PropertyType.byteVector)
  Uint8List? blob;

  String? publicHttpUrl;
  
  String bucketPath;

  String fileNameWithExt;

  Image(this.bucketPath,this.fileNameWithExt);
  
  bool get uploaded=> publicHttpUrl!=null;

  void setHttpUrl(String url){
    publicHttpUrl = url;
    blob = null;
  }
}
