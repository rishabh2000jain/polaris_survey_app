import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:polaris_survey_app/common/aws_common.dart';

///[UploadFileUseCase] is responsible for uploading the files to aws
///s3 bucket and return a url of the same if the upload was successful.
@injectable
class UploadFileUseCase {
  Future<String?> upload(
      Uint8List blob, String filePath, String fileName) async {
    try {
      return await _generateAwsSignature(
          endpointUri: Uri.parse(buildFileUrl(filePath, fileName)), file: blob);
    } catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  Future<String?> _generateAwsSignature({
    required Uri endpointUri,
    required Uint8List file,
  }) async {
    const signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(
          AWSConstants.accessKeyId,
          AWSConstants.secretAccessKey,
          null,
          null,
        ),
      ),
    );
    final scope = AWSCredentialScope(
      region: AWSConstants.region,
      service: AWSService.s3,
    );
    final request = AWSHttpRequest(
      method: AWSHttpMethod.put,
      uri: endpointUri,
      headers: {
        AWSHeaders.contentType: lookupMimeType(endpointUri.toString()) ?? '',
      },
      body: file,
    );
    final signedRequest = await signer.sign(
      request,
      credentialScope: scope,
    );
    final resp = await signedRequest.send().response;
    if (resp.statusCode == 200) return endpointUri.toString();
    return null;
  }
}
