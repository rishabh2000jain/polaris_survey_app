import 'package:polaris_survey_app/core/remote_service/api_failure.dart';

enum DataSource {
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServiceError,
  connectionTimeOut,
  cancel,
  receiveTimeout,
  sendTimeout,
  cancelError,
  noInternetConnection,
  kDefault
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.noInternetConnection:
        return const Failure(
            message: 'Please check your internet connection',
            source: DataSource.noInternetConnection);
      default:
        return Failure(message: 'Oops! Something went wrong', source: this);
    }
  }
}

