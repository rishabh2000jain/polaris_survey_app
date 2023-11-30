import 'package:polaris_survey_app/core/remote_service/api_error_enum.dart';

class Failure {
  final String message;
  final DataSource source;

  const Failure({required this.message,required this.source});
}
