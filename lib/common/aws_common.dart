String buildFileUrl(String filePathOnBucket, String fileName) =>
    'https://${AWSConstants.bucketName}.${AWSConstants.s3Service}.${AWSConstants.region}.amazonaws.com/$filePathOnBucket/$fileName';

abstract class AWSConstants {
  static const String accessKeyId = 'AKIARUYJYFCSRJUWGKQY';
  static const String secretAccessKey =
      '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';
  static const String region = 'ap-south-1';
  static const String bucketName = 'assignments-list';
  static const String s3Service = 's3';
}
