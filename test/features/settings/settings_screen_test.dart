import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/features/settings/data/local_reminder_data_control_service.dart';
import 'package:pill_reminder/features/settings/presentation/settings_screen.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

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
}

class _Harness extends StatefulWidget {
  _Harness({
    FakeSetupPreferencesRepository? repository,
    FakeNotificationPermissionService? notifications,
  }) : repository =
           repository ?? FakeSetupPreferencesRepository(_completeState()),
       notifications = notifications ?? FakeNotificationPermissionService();

  final FakeSetupPreferencesRepository repository;
  final FakeNotificationPermissionService notifications;

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
