extension StringExtensions on String {
  String get fileName => split(RegExp(r'[/\\]')).last;
}
