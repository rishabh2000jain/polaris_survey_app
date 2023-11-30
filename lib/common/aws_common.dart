String buildFileUrl(String filePathOnBucket, String fileName) =>
    'https://${AWSConstants.bucketName}.${AWSConstants.s3Service}.${AWSConstants.region}.amazonaws.com/$filePathOnBucket/$fileName';

abstract class AWSConstants {
  static const String accessKeyId = '';
  static const String secretAccessKey = '';
  static const String region = 'ap-south-1';
  static const String bucketName = 'assignments-list';
  static const String s3Service = 's3';
}
