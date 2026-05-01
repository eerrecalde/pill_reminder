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

  @override
  String get scheduleReminderTitle => 'Schedule reminders';

  @override
  String get reminderTimesTitle => 'Reminder times';

  @override
  String get reminderTimesHelp => 'Choose up to four daily times.';

  @override
  String get reminderTimesSemantics => 'Reminder times';

  @override
  String get addReminderTime => 'Add reminder time';

  @override
  String get editReminderTime => 'Edit reminder time';

  @override
  String get removeReminderTime => 'Remove reminder time';

  @override
  String reminderTimeSemantics(Object time) {
    return 'Reminder time $time';
  }

  @override
  String get addOptionalEndDate => 'Add optional end date';

  @override
  String get clearEndDate => 'Clear end date';

  @override
  String get reviewScheduleTitle => 'Review schedule';

  @override
  String scheduleMedicationSummary(Object name) {
    return 'Medication: $name';
  }

  @override
  String scheduleTimesSummary(Object times) {
    return 'Times: $times';
  }

  @override
  String get scheduleRepeatsIndefinitely =>
      'Repeats every day until you edit or remove it.';

  @override
  String scheduleStopsOn(Object date) {
    return 'Stops on $date';
  }

  @override
  String get saveSchedule => 'Save schedule';

  @override
  String get scheduleSavedSemantics => 'Reminder schedule saved';

  @override
  String get scheduleNotificationsDeliverable =>
      'Reminder alerts can be delivered.';

  @override
  String get scheduleNotificationsNeedPermission =>
      'Schedule saved. Reminder alerts need notifications to be enabled.';

  @override
  String get scheduleNotificationsBlocked =>
      'Schedule saved. Enable notifications in device settings for alerts.';

  @override
  String get scheduleNotificationsUnavailable =>
      'Schedule saved. Reminder alerts are not available on this device.';

  @override
  String get scheduleInactiveMedicationError =>
      'Make this medication active before scheduling reminders.';

  @override
  String get scheduleMissingTimeError => 'Choose at least one reminder time.';

  @override
  String get scheduleDuplicateTimeError =>
      'This reminder time is already selected.';

  @override
  String get scheduleTooManyTimesError => 'Use four reminder times or fewer.';

  @override
  String get scheduleInvalidEndDateError =>
      'Choose an end date on or after the first reminder date.';

  @override
  String get todayDueNowTitle => 'Due now';

  @override
  String get todayUpcomingTitle => 'Coming up';

  @override
  String get todayMissedTitle => 'Missed';

  @override
  String get todayHandledTitle => 'Handled today';

  @override
  String get todayClearTitle => 'The rest of today is clear';

  @override
  String get todayClearBody =>
      'No more medication reminders need attention today.';

  @override
  String get todayNoMedicationsTitle => 'No medications saved yet';

  @override
  String get todayNoMedicationsBody =>
      'Add your first medication so reminders can be set up when you are ready.';

  @override
  String get todayNoActiveMedicationsTitle => 'No active medications right now';

  @override
  String get todayNoActiveMedicationsBody =>
      'Your saved medications are inactive, so they will not appear as due today.';

  @override
  String get todayNoSchedulesTitle => 'No reminders scheduled yet';

  @override
  String get todayNoSchedulesBody =>
      'Schedule a reminder for an active medication to see it here today.';

  @override
  String get todayManageMedications => 'Manage medications';

  @override
  String get todayMarkHandled => 'Mark handled';

  @override
  String todayReminderTime(Object time) {
    return '$time';
  }

  @override
  String get todayReminderStatusDueNow => 'Due now';

  @override
  String get todayReminderStatusUpcoming => 'Upcoming';

  @override
  String get todayReminderStatusMissed => 'Missed';

  @override
  String get todayReminderStatusHandled => 'Handled';

  @override
  String todayReminderSemantics(Object medication, Object time, Object status) {
    return '$medication, $time, $status';
  }

  @override
  String todayReminderSemanticsWithDose(
    Object medication,
    Object dose,
    Object time,
    Object status,
  ) {
    return '$medication, $dose, $time, $status';
  }

  @override
  String todayMarkHandledSemantics(Object medication, Object time) {
    return 'Mark $medication at $time as handled';
  }

  @override
  String get todayNotificationGuidance =>
      'Reminder alerts may need notification permission, but today\'s schedule is still shown here.';
}
