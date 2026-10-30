import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Future<void> loadEnglishTranslations() async {
  EasyLocalization.logger.enableBuildModes = [];
  final asset = await rootBundle.loadString('assets/translations/en.json');
  Localization.load(
    const Locale('en'),
    translations: Translations(
      Map<String, dynamic>.from(jsonDecode(asset) as Map),
    ),
  );
}
