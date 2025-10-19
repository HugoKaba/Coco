import 'package:flutter/widgets.dart';
import 'strings_en.dart';
import 'strings_fr.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    Locale locale;
    try {
      locale = Localizations.localeOf(context);
    } catch (_) {
      locale = WidgetsBinding.instance.platformDispatcher.locale;
    }
    return AppLocalizations(locale);
  }

  static final Map<String, Map<String, String>> _localized = {
    'en': stringsEn,
    'fr': stringsFr,
  };

  String t(String key) {
    final map = _localized[locale.languageCode] ?? stringsEn;
    return map[key] ?? key;
  }
}
