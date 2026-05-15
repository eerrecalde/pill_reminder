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
  String get editMedicationTitle => 'Edit medication';

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
  String get medicationStatusPaused => 'Paused';

  @override
  String get medicationStatusInactive => 'Inactive';

  @override
  String get medicationStatusActiveSemantics => 'Status, active';

  @override
  String get medicationStatusPausedSemantics =>
      'Status, paused. Reminders are stopped until you resume them.';

  @override
  String get medicationStatusInactiveSemantics => 'Status, inactive';

  @override
  String get medicationAvailableForReminders =>
      'Available for future reminder setup.';

  @override
  String get medicationPausedExplanation =>
      'Reminders are paused until you resume them.';

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
  String get saveMedicationChanges => 'Save changes';

  @override
  String get editMedicationAction => 'Edit';

  @override
  String get pauseRemindersAction => 'Pause reminders';

  @override
  String get resumeRemindersAction => 'Resume reminders';

  @override
  String get deleteMedicationAction => 'Delete medication';

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
  String get medicationUpdatedSemantics => 'Medication updated';

  @override
  String get medicationNotSavedSemantics => 'Medication was not saved';

  @override
  String get remindersPaused => 'Reminders paused.';

  @override
  String get remindersResumed => 'Reminders resumed.';

  @override
  String get medicationDeleted => 'Medication deleted.';

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
  String get deleteScheduleAction => 'Delete schedule';

  @override
  String get scheduleDeleted => 'Reminder schedule deleted.';

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
  String get deleteFinalWarning => 'This cannot be undone.';

  @override
  String get deleteScheduleConfirmationTitle => 'Delete reminder schedule?';

  @override
  String deleteScheduleConfirmationMessage(Object name) {
    return 'The reminder times for $name will be removed. The medication will stay saved.';
  }

  @override
  String get deleteMedicationConfirmationTitle => 'Delete medication?';

  @override
  String deleteMedicationConfirmationMessage(Object name) {
    return '$name and its reminders will be removed from this device.';
  }

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
  String get dueReminderTitle => 'Medication reminder';

  @override
  String dueReminderScheduledTime(Object time) {
    return 'Scheduled for $time';
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

  @override
  String get dueReminderStateUnresolved => 'This reminder is due.';

  @override
  String get dueReminderStateTaken => 'Marked as taken.';

  @override
  String get dueReminderStateSkipped => 'Skipped.';

  @override
  String get dueReminderStateLater => 'You will be reminded again later.';

  @override
  String get dueReminderTakenAction => 'Taken';

  @override
  String get dueReminderSkipAction => 'Skip';

  @override
  String get dueReminderLaterAction => 'Remind later';

  @override
  String get dueReminderPermissionNeeded =>
      'Reminder alerts need notifications to be enabled. You can still handle this reminder here.';

  @override
  String get dueReminderPermissionBlocked =>
      'Reminder alerts need to be enabled in device settings. You can still handle this reminder here.';

  @override
  String get dueReminderPermissionUnavailable =>
      'Reminder alerts are not available on this device. You can still handle this reminder here.';

  @override
  String get dueReminderBannerTitle => 'Due reminders';

  @override
  String dueReminderBannerItem(Object name) {
    return '$name is due';
  }

  @override
  String dueReminderBannerSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count due reminders',
      one: '1 due reminder',
    );
    return '$_temp0';
  }

  @override
  String get medicationHistoryOpen => 'Medication history';

  @override
  String get medicationHistoryTitle => 'Medication history';

  @override
  String get medicationHistoryIntro =>
      'Recent reminder activity stays on this device.';

  @override
  String get medicationHistoryEmptyTitle => 'No history yet';

  @override
  String get medicationHistoryEmptyBody =>
      'Taken, skipped, missed, and snoozed reminders will appear here after activity is recorded.';

  @override
  String get medicationHistoryStatusTaken => 'Taken';

  @override
  String get medicationHistoryStatusSkipped => 'Skipped';

  @override
  String get medicationHistoryStatusMissed => 'Missed';

  @override
  String get medicationHistoryStatusSnoozed => 'Snoozed';

  @override
  String medicationHistoryDaySemantics(Object date) {
    return 'Medication history for $date';
  }

  @override
  String medicationHistoryRowSemantics(
    Object date,
    Object medication,
    Object time,
    Object status,
  ) {
    return '$date, $medication, $time, $status';
  }

  @override
  String medicationHistoryRowSemanticsWithDose(
    Object date,
    Object medication,
    Object dose,
    Object time,
    Object status,
  ) {
    return '$date, $medication, $dose, $time, $status';
  }

  @override
  String get reminderHandlingSettingsTitle => 'Reminder handling';

  @override
  String get reminderHandlingIntervalLabel => 'Remind again later after';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose the language for settings, setup, and reminder guidance.';

  @override
  String get settingsLanguageSemantics => 'Preferred language';

  @override
  String get settingsLanguageSaved => 'Language updated.';

  @override
  String get settingsAccessibilityTitle => 'Accessibility';

  @override
  String get settingsAccessibilityDescription =>
      'The app follows your device settings for text size, screen reader, focus, and contrast.';

  @override
  String get settingsAccessibilityDeviceSupport =>
      'Use your device accessibility settings to adjust how the app looks and speaks. Content will scroll and reflow instead of hiding controls.';

  @override
  String get settingsNotificationsTitle => 'Reminder alerts';

  @override
  String get settingsNotificationsDescription =>
      'Check whether this device can show reminder notifications.';

  @override
  String get settingsNotificationAllowed => 'Reminder alerts are on.';

  @override
  String get settingsNotificationDenied =>
      'Reminder alerts may not appear until notifications are allowed.';

  @override
  String get settingsNotificationBlocked =>
      'Reminder alerts are blocked or restricted. You can adjust this in device settings if you choose.';

  @override
  String get settingsNotificationUnavailable =>
      'The app cannot confirm reminder alerts on this device right now. Try again later.';

  @override
  String get settingsNotificationRefresh => 'Refresh status';

  @override
  String get settingsNotificationOpenDeviceSettings => 'Open device settings';

  @override
  String get settingsPrivacyTitle => 'Privacy';

  @override
  String get settingsPrivacyDescription =>
      'Medication and reminder information stays local to this device.';

  @override
  String get settingsPrivacyLocalOnly =>
      'Medication names, reminder schedules, due reminders, handling state, and history are saved only on this device.';

  @override
  String get settingsPrivacyNoAccounts =>
      'There are no accounts, ads, tracking, backup, sync, sharing, analytics, donation prompts, or remote services in this settings feature.';

  @override
  String get settingsLocalDataTitle => 'Local reminder data';

  @override
  String get settingsLocalDataDescription =>
      'Review and control medication and reminder data saved on this device.';

  @override
  String get settingsLocalDataFound =>
      'There is local medication or reminder data on this device.';

  @override
  String get settingsNoLocalData =>
      'There is no local medication or reminder data to delete right now.';

  @override
  String get settingsDeleteLocalDataAction => 'Delete local reminder data';

  @override
  String get settingsDeleteConfirmationTitle => 'Delete local reminder data?';

  @override
  String get settingsDeleteConfirmationBody =>
      'This removes medication records, reminder schedules, due reminders, reminder handling state, and medication history from this device.';

  @override
  String get settingsDeleteConfirmAction => 'Delete data';

  @override
  String get settingsDataDeleted => 'Local reminder data deleted.';

  @override
  String get settingsUndoDeleteAction => 'Restore';

  @override
  String get settingsRecoveryAvailable =>
      'You can restore the deleted data for 30 seconds.';

  @override
  String get settingsRecoveryExpired =>
      'The 30-second restore window has ended.';

  @override
  String get settingsDataRestored => 'Local reminder data restored.';

  @override
  String get settingsDeleteFailed =>
      'Local reminder data was not deleted. Your data is still available.';

  @override
  String get settingsRestoreFailed =>
      'Local reminder data could not be restored.';

  @override
  String get settingsNotificationSoundTitle => 'Notification sound';

  @override
  String get settingsNotificationSoundDescription =>
      'Choose the sound used for medication reminders.';

  @override
  String settingsNotificationSoundCurrent(Object sound) {
    return 'Current sound: $sound';
  }

  @override
  String get settingsNotificationSoundDeviceLimits =>
      'Device mute, focus, do-not-disturb, notification permission, and channel settings can prevent the chosen sound from playing.';

  @override
  String get settingsNotificationSoundUnavailable =>
      'The previously selected sound is no longer available. Reminders will use the default sound until you choose another.';

  @override
  String get settingsNotificationSoundChoose => 'Choose sound';

  @override
  String get notificationRingtonePickerTitle => 'Notification sound';

  @override
  String get notificationRingtoneDefault => 'Default reminder sound';

  @override
  String get notificationRingtoneGentleChime => 'Gentle chime';

  @override
  String get notificationRingtoneBrightBell => 'Bright bell';

  @override
  String get notificationRingtoneSoftPulse => 'Soft pulse';

  @override
  String get notificationRingtonePillsInBox => 'Pills in a box';

  @override
  String get notificationRingtoneCurrent => 'Current';

  @override
  String get notificationRingtoneSelected => 'Selected';

  @override
  String get notificationRingtoneUnavailable => 'Unavailable';

  @override
  String get notificationRingtonePreview => 'Preview';

  @override
  String notificationRingtonePreviewNamed(Object sound) {
    return 'Preview $sound';
  }

  @override
  String get notificationRingtoneStopPreview => 'Stop preview';

  @override
  String get notificationRingtoneSave => 'Save sound';

  @override
  String get notificationRingtoneSaved => 'Notification sound saved.';

  @override
  String notificationRingtoneRowSemantics(Object sound, Object status) {
    return '$sound. $status';
  }

  @override
  String get notificationRingtoneUnavailableWarning =>
      'Your previous sound is unavailable. Choose another sound to clear this warning.';

  @override
  String get notificationRingtoneDeviceLimits =>
      'Your phone settings may still silence reminders even when this sound is saved.';
}
