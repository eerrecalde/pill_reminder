// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pill Reminder';

  @override
  String get mainTitle => 'Today';

  @override
  String get mainPlaceholder => 'Your reminders will appear here.';

  @override
  String get setupPreferences => 'Setup preferences';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get english => 'English';

  @override
  String get spanishLatinAmerica => 'Español (Latinoamérica)';

  @override
  String get selected => 'Selected';

  @override
  String get back => 'Back';

  @override
  String get yourInformationStaysWithYou => 'Your information stays with you';

  @override
  String get privacyBodyLineOne =>
      'Your medication reminders are saved only on this device.';

  @override
  String get privacyBodyLineTwo => 'No account. No sharing.';

  @override
  String get continueAction => 'Continue';

  @override
  String get getReminderAlerts => 'Get reminder alerts';

  @override
  String get notificationBody =>
      'We can remind you when it\'s time to take your medication.';

  @override
  String get turnOnReminders => 'Turn on reminders';

  @override
  String get notNow => 'Not now';

  @override
  String get remindersOn => 'Reminders are on';

  @override
  String get remindersUnavailableTitle => 'Reminder alerts are off';

  @override
  String get remindersUnavailableBody =>
      'Reminders cannot be delivered until notifications are enabled.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get languageSettingTitle => 'Language';

  @override
  String get notificationSettingTitle => 'Reminder alerts';

  @override
  String get notificationSettingGranted => 'Reminder alerts can be delivered.';

  @override
  String get notificationSettingSkipped =>
      'Reminder alerts are off. You can turn them on when you are ready.';

  @override
  String get notificationSettingDenied =>
      'Reminder alerts are off until notifications are enabled.';

  @override
  String get notificationSettingBlocked =>
      'Reminder alerts need to be enabled in device settings.';

  @override
  String get notificationSettingUnavailable =>
      'Reminder alerts are not available on this device.';

  @override
  String get changeLanguageHelp =>
      'Choose the language for setup and reminder guidance.';
}
