import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pill Reminder'**
  String get appTitle;

  /// No description provided for @mainTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get mainTitle;

  /// No description provided for @mainPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your reminders will appear here.'**
  String get mainPlaceholder;

  /// No description provided for @setupPreferences.
  ///
  /// In en, this message translates to:
  /// **'Setup preferences'**
  String get setupPreferences;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanishLatinAmerica.
  ///
  /// In en, this message translates to:
  /// **'Español (Latinoamérica)'**
  String get spanishLatinAmerica;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @yourInformationStaysWithYou.
  ///
  /// In en, this message translates to:
  /// **'Your information stays with you'**
  String get yourInformationStaysWithYou;

  /// No description provided for @privacyBodyLineOne.
  ///
  /// In en, this message translates to:
  /// **'Your medication reminders are saved only on this device.'**
  String get privacyBodyLineOne;

  /// No description provided for @privacyBodyLineTwo.
  ///
  /// In en, this message translates to:
  /// **'No account. No sharing.'**
  String get privacyBodyLineTwo;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @getReminderAlerts.
  ///
  /// In en, this message translates to:
  /// **'Get reminder alerts'**
  String get getReminderAlerts;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'We can remind you when it\'s time to take your medication.'**
  String get notificationBody;

  /// No description provided for @turnOnReminders.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get turnOnReminders;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @remindersOn.
  ///
  /// In en, this message translates to:
  /// **'Reminders are on'**
  String get remindersOn;

  /// No description provided for @remindersUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts are off'**
  String get remindersUnavailableTitle;

  /// No description provided for @remindersUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders cannot be delivered until notifications are enabled.'**
  String get remindersUnavailableBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @languageSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingTitle;

  /// No description provided for @notificationSettingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts'**
  String get notificationSettingTitle;

  /// No description provided for @notificationSettingGranted.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts can be delivered.'**
  String get notificationSettingGranted;

  /// No description provided for @notificationSettingSkipped.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts are off. You can turn them on when you are ready.'**
  String get notificationSettingSkipped;

  /// No description provided for @notificationSettingDenied.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts are off until notifications are enabled.'**
  String get notificationSettingDenied;

  /// No description provided for @notificationSettingBlocked.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts need to be enabled in device settings.'**
  String get notificationSettingBlocked;

  /// No description provided for @notificationSettingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts are not available on this device.'**
  String get notificationSettingUnavailable;

  /// No description provided for @changeLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose the language for setup and reminder guidance.'**
  String get changeLanguageHelp;

  /// No description provided for @addMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'Add medication'**
  String get addMedicationTitle;

  /// No description provided for @medicationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medicationsSectionTitle;

  /// No description provided for @medicationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No medications saved yet'**
  String get medicationsEmptyTitle;

  /// No description provided for @medicationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a medication now so it can be chosen for reminders later.'**
  String get medicationsEmptyBody;

  /// No description provided for @medicationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medication name (required)'**
  String get medicationNameLabel;

  /// No description provided for @medicationNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, morning pill'**
  String get medicationNameHint;

  /// No description provided for @medicationDosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage label (optional)'**
  String get medicationDosageLabel;

  /// No description provided for @medicationDosageHint.
  ///
  /// In en, this message translates to:
  /// **'For example, 1 tablet'**
  String get medicationDosageHint;

  /// No description provided for @medicationNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get medicationNotesLabel;

  /// No description provided for @medicationNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything you want to remember'**
  String get medicationNotesHint;

  /// No description provided for @medicationStatusSemantics.
  ///
  /// In en, this message translates to:
  /// **'Medication status'**
  String get medicationStatusSemantics;

  /// No description provided for @medicationStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get medicationStatusActive;

  /// No description provided for @medicationStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get medicationStatusInactive;

  /// No description provided for @medicationStatusActiveSemantics.
  ///
  /// In en, this message translates to:
  /// **'Status, active'**
  String get medicationStatusActiveSemantics;

  /// No description provided for @medicationStatusInactiveSemantics.
  ///
  /// In en, this message translates to:
  /// **'Status, inactive'**
  String get medicationStatusInactiveSemantics;

  /// No description provided for @medicationAvailableForReminders.
  ///
  /// In en, this message translates to:
  /// **'Available for future reminder setup.'**
  String get medicationAvailableForReminders;

  /// No description provided for @medicationStoredInactive.
  ///
  /// In en, this message translates to:
  /// **'Stored as inactive. It will not be treated as ready for reminders.'**
  String get medicationStoredInactive;

  /// No description provided for @addMedicationPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your medication stays on this device'**
  String get addMedicationPrivacyTitle;

  /// No description provided for @addMedicationPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'No account or internet is needed to add it.'**
  String get addMedicationPrivacyBody;

  /// No description provided for @saveMedication.
  ///
  /// In en, this message translates to:
  /// **'Save medication'**
  String get saveMedication;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @duplicateMedicationTitle.
  ///
  /// In en, this message translates to:
  /// **'This name is already saved'**
  String get duplicateMedicationTitle;

  /// No description provided for @duplicateMedicationMessage.
  ///
  /// In en, this message translates to:
  /// **'Another medication has this name. You can save this one too if it is correct.'**
  String get duplicateMedicationMessage;

  /// No description provided for @saveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get saveAnyway;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @medicationSavedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Medication saved'**
  String get medicationSavedSemantics;

  /// No description provided for @medicationNotSavedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Medication was not saved'**
  String get medicationNotSavedSemantics;

  /// No description provided for @medicationNameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a medication name.'**
  String get medicationNameRequiredError;

  /// No description provided for @medicationNameTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Use 80 characters or fewer for the medication name.'**
  String get medicationNameTooLongError;

  /// No description provided for @medicationDosageTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Use 80 characters or fewer for the dosage label.'**
  String get medicationDosageTooLongError;

  /// No description provided for @medicationNotesTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Use 500 characters or fewer for notes.'**
  String get medicationNotesTooLongError;

  /// No description provided for @medicationValidationGenericError.
  ///
  /// In en, this message translates to:
  /// **'Check the highlighted field.'**
  String get medicationValidationGenericError;

  /// No description provided for @scheduleReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule reminders'**
  String get scheduleReminderTitle;

  /// No description provided for @reminderTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get reminderTimesTitle;

  /// No description provided for @reminderTimesHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose up to four daily times.'**
  String get reminderTimesHelp;

  /// No description provided for @reminderTimesSemantics.
  ///
  /// In en, this message translates to:
  /// **'Reminder times'**
  String get reminderTimesSemantics;

  /// No description provided for @addReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Add reminder time'**
  String get addReminderTime;

  /// No description provided for @editReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder time'**
  String get editReminderTime;

  /// No description provided for @removeReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder time'**
  String get removeReminderTime;

  /// No description provided for @reminderTimeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Reminder time {time}'**
  String reminderTimeSemantics(Object time);

  /// No description provided for @addOptionalEndDate.
  ///
  /// In en, this message translates to:
  /// **'Add optional end date'**
  String get addOptionalEndDate;

  /// No description provided for @clearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get clearEndDate;

  /// No description provided for @reviewScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Review schedule'**
  String get reviewScheduleTitle;

  /// No description provided for @scheduleMedicationSummary.
  ///
  /// In en, this message translates to:
  /// **'Medication: {name}'**
  String scheduleMedicationSummary(Object name);

  /// No description provided for @scheduleTimesSummary.
  ///
  /// In en, this message translates to:
  /// **'Times: {times}'**
  String scheduleTimesSummary(Object times);

  /// No description provided for @scheduleRepeatsIndefinitely.
  ///
  /// In en, this message translates to:
  /// **'Repeats every day until you edit or remove it.'**
  String get scheduleRepeatsIndefinitely;

  /// No description provided for @scheduleStopsOn.
  ///
  /// In en, this message translates to:
  /// **'Stops on {date}'**
  String scheduleStopsOn(Object date);

  /// No description provided for @saveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save schedule'**
  String get saveSchedule;

  /// No description provided for @scheduleSavedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Reminder schedule saved'**
  String get scheduleSavedSemantics;

  /// No description provided for @scheduleNotificationsDeliverable.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts can be delivered.'**
  String get scheduleNotificationsDeliverable;

  /// No description provided for @scheduleNotificationsNeedPermission.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved. Reminder alerts need notifications to be enabled.'**
  String get scheduleNotificationsNeedPermission;

  /// No description provided for @scheduleNotificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved. Enable notifications in device settings for alerts.'**
  String get scheduleNotificationsBlocked;

  /// No description provided for @scheduleNotificationsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved. Reminder alerts are not available on this device.'**
  String get scheduleNotificationsUnavailable;

  /// No description provided for @scheduleInactiveMedicationError.
  ///
  /// In en, this message translates to:
  /// **'Make this medication active before scheduling reminders.'**
  String get scheduleInactiveMedicationError;

  /// No description provided for @scheduleMissingTimeError.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one reminder time.'**
  String get scheduleMissingTimeError;

  /// No description provided for @scheduleDuplicateTimeError.
  ///
  /// In en, this message translates to:
  /// **'This reminder time is already selected.'**
  String get scheduleDuplicateTimeError;

  /// No description provided for @scheduleTooManyTimesError.
  ///
  /// In en, this message translates to:
  /// **'Use four reminder times or fewer.'**
  String get scheduleTooManyTimesError;

  /// No description provided for @scheduleInvalidEndDateError.
  ///
  /// In en, this message translates to:
  /// **'Choose an end date on or after the first reminder date.'**
  String get scheduleInvalidEndDateError;

  /// No description provided for @todayDueNowTitle.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get todayDueNowTitle;

  /// No description provided for @todayUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get todayUpcomingTitle;

  /// No description provided for @todayMissedTitle.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get todayMissedTitle;

  /// No description provided for @todayHandledTitle.
  ///
  /// In en, this message translates to:
  /// **'Handled today'**
  String get todayHandledTitle;

  /// No description provided for @todayClearTitle.
  ///
  /// In en, this message translates to:
  /// **'The rest of today is clear'**
  String get todayClearTitle;

  /// No description provided for @todayClearBody.
  ///
  /// In en, this message translates to:
  /// **'No more medication reminders need attention today.'**
  String get todayClearBody;

  /// No description provided for @todayNoMedicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No medications saved yet'**
  String get todayNoMedicationsTitle;

  /// No description provided for @todayNoMedicationsBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first medication so reminders can be set up when you are ready.'**
  String get todayNoMedicationsBody;

  /// No description provided for @todayNoActiveMedicationsTitle.
  ///
  /// In en, this message translates to:
  /// **'No active medications right now'**
  String get todayNoActiveMedicationsTitle;

  /// No description provided for @todayNoActiveMedicationsBody.
  ///
  /// In en, this message translates to:
  /// **'Your saved medications are inactive, so they will not appear as due today.'**
  String get todayNoActiveMedicationsBody;

  /// No description provided for @todayNoSchedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders scheduled yet'**
  String get todayNoSchedulesTitle;

  /// No description provided for @todayNoSchedulesBody.
  ///
  /// In en, this message translates to:
  /// **'Schedule a reminder for an active medication to see it here today.'**
  String get todayNoSchedulesBody;

  /// No description provided for @todayManageMedications.
  ///
  /// In en, this message translates to:
  /// **'Manage medications'**
  String get todayManageMedications;

  /// No description provided for @todayMarkHandled.
  ///
  /// In en, this message translates to:
  /// **'Mark handled'**
  String get todayMarkHandled;

  /// No description provided for @todayReminderTime.
  ///
  /// In en, this message translates to:
  /// **'{time}'**
  String todayReminderTime(Object time);

  /// No description provided for @todayReminderStatusDueNow.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get todayReminderStatusDueNow;

  /// No description provided for @todayReminderStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get todayReminderStatusUpcoming;

  /// No description provided for @todayReminderStatusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get todayReminderStatusMissed;

  /// No description provided for @todayReminderStatusHandled.
  ///
  /// In en, this message translates to:
  /// **'Handled'**
  String get todayReminderStatusHandled;

  /// No description provided for @todayReminderSemantics.
  ///
  /// In en, this message translates to:
  /// **'{medication}, {time}, {status}'**
  String todayReminderSemantics(Object medication, Object time, Object status);

  /// No description provided for @todayReminderSemanticsWithDose.
  ///
  /// In en, this message translates to:
  /// **'{medication}, {dose}, {time}, {status}'**
  String todayReminderSemanticsWithDose(
    Object medication,
    Object dose,
    Object time,
    Object status,
  );

  /// No description provided for @todayMarkHandledSemantics.
  ///
  /// In en, this message translates to:
  /// **'Mark {medication} at {time} as handled'**
  String todayMarkHandledSemantics(Object medication, Object time);

  /// No description provided for @todayNotificationGuidance.
  ///
  /// In en, this message translates to:
  /// **'Reminder alerts may need notification permission, but today\'s schedule is still shown here.'**
  String get todayNotificationGuidance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
