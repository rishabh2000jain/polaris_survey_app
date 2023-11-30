import 'package:dio/dio.dart';
import 'package:polaris_survey_app/constants.dart';

const String kApplicationJson = "application/json";
const String kContentType = "content-type";
const String kAccept = "accept";

class DioFactory {

  Dio getDio() {
    Dio dio = Dio();
    Map<String, String> headers = {
      kContentType: kApplicationJson,
      kAccept: kApplicationJson,
    };

    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: headers,
      receiveTimeout: AppConstants.apiTimeOut,
      sendTimeout: AppConstants.apiTimeOut,
    );

    return dio;
  }
}