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

  @override
  String get addMedicationTitle => 'Add medication';

  @override
  String get medicationsSectionTitle => 'Medications';

  @override
  String get medicationsEmptyTitle => 'No medications saved yet';

  @override
  String get medicationsEmptyBody =>
      'Add a medication now so it can be chosen for reminders later.';

  @override
  String get medicationNameLabel => 'Medication name (required)';

  @override
  String get medicationNameHint => 'For example, morning pill';

  @override
  String get medicationDosageLabel => 'Dosage label (optional)';

  @override
  String get medicationDosageHint => 'For example, 1 tablet';

  @override
  String get medicationNotesLabel => 'Notes (optional)';

  @override
  String get medicationNotesHint => 'Anything you want to remember';

  @override
  String get medicationStatusSemantics => 'Medication status';

  @override
  String get medicationStatusActive => 'Active';

  @override
  String get medicationStatusInactive => 'Inactive';

  @override
  String get medicationStatusActiveSemantics => 'Status, active';

  @override
  String get medicationStatusInactiveSemantics => 'Status, inactive';

  @override
  String get medicationAvailableForReminders =>
      'Available for future reminder setup.';

  @override
  String get medicationStoredInactive =>
      'Stored as inactive. It will not be treated as ready for reminders.';

  @override
  String get addMedicationPrivacyTitle =>
      'Your medication stays on this device';

  @override
  String get addMedicationPrivacyBody =>
      'No account or internet is needed to add it.';

  @override
  String get saveMedication => 'Save medication';

  @override
  String get cancel => 'Cancel';

  @override
  String get duplicateMedicationTitle => 'This name is already saved';

  @override
  String get duplicateMedicationMessage =>
      'Another medication has this name. You can save this one too if it is correct.';

  @override
  String get saveAnyway => 'Save anyway';

  @override
  String get goBack => 'Go back';

  @override
  String get medicationSavedSemantics => 'Medication saved';

  @override
  String get medicationNotSavedSemantics => 'Medication was not saved';

  @override
  String get medicationNameRequiredError => 'Enter a medication name.';

  @override
  String get medicationNameTooLongError =>
      'Use 80 characters or fewer for the medication name.';

  @override
  String get medicationDosageTooLongError =>
      'Use 80 characters or fewer for the dosage label.';

  @override
  String get medicationNotesTooLongError =>
      'Use 500 characters or fewer for notes.';

  @override
  String get medicationValidationGenericError => 'Check the highlighted field.';
}
