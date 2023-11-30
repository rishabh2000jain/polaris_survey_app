class AwsFileUploadData{
  final String url;
  final Map<String, String> fields;

  AwsFileUploadData({
    required this.url,
    required this.fields,
  });

  factory AwsFileUploadData.fromJson(Map<String, dynamic> json) {
    return AwsFileUploadData(
      url: json['url'],
      fields: Map<String, String>.from(json['fields']),
    );
  }
}