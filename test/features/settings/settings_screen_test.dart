import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone.dart';
import 'package:pill_reminder/features/notifications/domain/notification_ringtone_catalog.dart';
import 'package:pill_reminder/features/settings/data/local_reminder_data_control_service.dart';
import 'package:pill_reminder/features/settings/presentation/settings_screen.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import '../notifications/fakes/fake_notification_ringtone_repository.dart';
import '../medications/fakes/fake_daily_reminder_handling_repository.dart';
import '../medications/fakes/fake_due_reminder_repository.dart';
import '../medications/fakes/fake_medication_history_repository.dart';
import '../medications/fakes/fake_medication_repository.dart';
import '../medications/fakes/fake_reminder_notification_scheduler.dart';
import '../medications/fakes/fake_reminder_schedule_repository.dart';
import '../setup/fakes/fake_notification_permission_service.dart';
import '../setup/fakes/fake_setup_preferences_repository.dart';

void main() {
  testWidgets('shows all sections without account ads or tracking prompts', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness());
    await tester.pumpAndSettle();

    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Accessibility'), findsOneWidget);
    expect(find.text('Reminder alerts'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Privacy'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Privacy'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Local reminder data'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Local reminder data'), findsOneWidget);
    expect(find.textContaining('no accounts'), findsOneWidget);
    expect(find.textContaining('ads'), findsOneWidget);
    expect(find.textContaining('tracking'), findsOneWidget);
    expect(find.textContaining('Sign in'), findsNothing);
  });

  testWidgets('switches language immediately from settings', (tester) async {
    final repository = FakeSetupPreferencesRepository(_completeState());
    await tester.pumpWidget(_Harness(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Español (Latinoamérica)'));
    await tester.pumpAndSettle();

    expect(find.text('Configuración'), findsOneWidget);
    expect(
      (await repository.load()).language,
      SetupLanguage.spanishLatinAmerica,
    );
  });

  testWidgets('renders notification denied state and opens device settings', (
    tester,
  ) async {
    final notifications = FakeNotificationPermissionService(
      currentStatus: SetupNotificationPermissionStatus.blocked,
    );
    await tester.pumpWidget(_Harness(notifications: notifications));
    await tester.pumpAndSettle();

    expect(find.textContaining('blocked or restricted'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    final settingsButton = find.widgetWithText(
      TextButton,
      'Open device settings',
    );
    await tester.tap(settingsButton);
    await tester.pump();

    expect(notifications.openedSettings, isTrue);
  });

  testWidgets('shows current ringtone and opens picker from settings', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    final ringtoneRepository = FakeNotificationRingtoneRepository(
      selectedRingtoneId: 'gentle_chime',
    );
    await tester.pumpWidget(_Harness(ringtoneRepository: ringtoneRepository));
    await tester.pumpAndSettle();

    expect(find.text('Notification sound'), findsOneWidget);
    expect(find.text('Current sound: Gentle chime'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Choose sound'),
      300,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.widgetWithText(OutlinedButton, 'Choose sound'));
    await tester.pumpAndSettle();

    expect(find.text('Default reminder sound'), findsOneWidget);
  });

  testWidgets('explains unavailable ringtone and preserves privacy posture', (
    tester,
  ) async {
    await _setLargeSurface(tester);
    const unavailableOption = RingtoneOption(
      id: 'old_chime',
      displayNameKey: 'notificationRingtoneGentleChime',
      previewAssetPath: 'assets/audio/notifications/gentle_chime.wav',
      androidRawResourceName: 'gentle_chime',
      iosSoundFileName: 'gentle_chime.wav',
      isDefault: false,
      isAvailable: false,
    );
    await tester.pumpWidget(
      _Harness(
        ringtoneRepository: FakeNotificationRingtoneRepository(
          options: [...bundledNotificationRingtones, unavailableOption],
          selectedRingtoneId: 'old_chime',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('previously selected sound is no longer available'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Privacy'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.textContaining('accounts'), findsOneWidget);
    expect(find.textContaining('ads'), findsOneWidget);
    expect(find.textContaining('tracking'), findsOneWidget);
    expect(find.textContaining('media library'), findsNothing);
    expect(find.textContaining('Sign in'), findsNothing);
  });
}

Future<void> _setLargeSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(900, 1200));
  tester.view.devicePixelRatio = 1;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.view.resetDevicePixelRatio();
  });
}

class _Harness extends StatefulWidget {
  _Harness({
    FakeSetupPreferencesRepository? repository,
    FakeNotificationPermissionService? notifications,
    FakeNotificationRingtoneRepository? ringtoneRepository,
  }) : repository =
           repository ?? FakeSetupPreferencesRepository(_completeState()),
       notifications = notifications ?? FakeNotificationPermissionService(),
       ringtoneRepository =
           ringtoneRepository ?? FakeNotificationRingtoneRepository();

  final FakeSetupPreferencesRepository repository;
  final FakeNotificationPermissionService notifications;
  final FakeNotificationRingtoneRepository ringtoneRepository;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: SettingsScreen(
        repository: widget.repository,
        notificationPermissionService: widget.notifications,
        dataControlService: LocalReminderDataControlService(
          medicationRepository: FakeMedicationRepository(),
          reminderScheduleRepository: FakeReminderScheduleRepository(),
          dueReminderRepository: FakeDueReminderRepository(),
          dailyReminderHandlingRepository:
              FakeDailyReminderHandlingRepository(),
          medicationHistoryRepository: FakeMedicationHistoryRepository(),
          notificationScheduler: FakeReminderNotificationScheduler(),
        ),
        initialState: _completeState(),
        ringtoneRepository: widget.ringtoneRepository,
        onLocaleChanged: (locale) => setState(() => _locale = locale),
        onStateChanged: (_) {},
      ),
    );
  }
}

SetupState _completeState() {
  return SetupState(
    language: SetupLanguage.english,
    currentStep: SetupStep.complete,
    privacyAcknowledged: true,
    notificationStatus: SetupNotificationPermissionStatus.granted,
    isComplete: true,
  );
}
