import 'package:flutter/widgets.dart';

enum SetupLanguage {
  english(Locale('en'), 'English'),
  spanishLatinAmerica(Locale('es', '419'), 'Español (Latinoamérica)');

  const SetupLanguage(this.locale, this.displayName);

  final Locale locale;
  final String displayName;

  String get localeCode {
    if (locale.countryCode == null || locale.countryCode!.isEmpty) {
      return locale.languageCode;
    }
    return '${locale.languageCode}_${locale.countryCode}';
  }

  static SetupLanguage fromLocaleCode(String? value) {
    return switch (value) {
      'es_419' => SetupLanguage.spanishLatinAmerica,
      _ => SetupLanguage.english,
    };
  }
}
