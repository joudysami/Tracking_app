bool isCurrentPasswordError(String message) {
  final value = message.toLowerCase();
  return value.contains('current password') ||
      value.contains('invalid password') ||
      value.contains('incorrect');
}
