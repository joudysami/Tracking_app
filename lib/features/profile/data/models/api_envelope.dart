bool readApiSuccess(Map<String, dynamic> json) {
  final value = json['success'] ?? json['isSuccess'] ?? json['status'];
  if (value is bool) return value;
  if (value is num) return value == 1;
  return json.containsKey('data');
}

String? readApiMessage(Map<String, dynamic> json) {
  final message = json['message'];
  if (message == null) return null;
  return message.toString();
}
