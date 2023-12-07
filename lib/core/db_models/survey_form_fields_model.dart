import 'package:objectbox/objectbox.dart';

@Entity()
class SurveyFormFieldsDbModel {
  @Id()
  int id = 0;
  String formData;

  SurveyFormFieldsDbModel(this.formData);

}
