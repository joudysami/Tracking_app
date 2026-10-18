import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/core/localization/local_key.dart';

enum ApplyError { completeRequiredFields }

extension ApplyErrorMapper on ApplyError {
  String toLocalizedMessage() {
    switch (this) {
      case ApplyError.completeRequiredFields:
        return LocaleKeys.applyCompleteRequiredFields.tr();
    }
  }
}
