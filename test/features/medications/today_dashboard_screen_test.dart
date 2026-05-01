import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/medications/presentation/today_dashboard_screen.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import '../setup/fakes/fake_notification_permission_service.dart';
import 'fakes/fake_daily_reminder_handling_repository.dart';
import 'fakes/fake_due_reminder_repository.dart';
import 'fakes/fake_medication_repository.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';
import 'fakes/fake_reminder_schedule_repository.dart';
import 'reminder_schedule_test_fixtures.dart';
import 'today_dashboard_test_fixtures.dart';

void main() {
  testWidgets('shows grouped dashboard sections and marks upcoming handled', (
    tester,
  ) async {
    final handlingRepository = FakeDailyReminderHandlingRepository([
      todayHandlingFixture(reminderTime: reminderTimeFixture(hour: 8)),
    ]);
    final scheduler = FakeReminderNotificationScheduler();

    await tester.pumpWidget(
      _DashboardHarness(
        medications: [todayMedicationFixture(name: 'Aspirin')],
        schedules: [
          todayScheduleFixture(
            reminderTimes: [
              reminderTimeFixture(hour: 8),
              reminderTimeFixture(hour: 9),
              reminderTimeFixture(hour: 12),
            ],
          ),
        ],
        handlingRepository: handlingRepository,
        scheduler: scheduler,
        now: DateTime(2026, 5, 1, 9, 15),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Due now'), findsWidgets);
    expect(find.text('Coming up'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Handled today'), 300);
    expect(find.text('Handled today'), findsOneWidget);
    expect(find.text('Aspirin'), findsWidgets);

    await tester.ensureVisible(find.text('Mark handled').last);
    await tester.tap(find.text('Mark handled').last);
    await tester.pump();
    await tester.pump();

    expect(handlingRepository.markHandledCount, 1);
    expect(scheduler.suppressedTimes, [reminderTimeFixture(hour: 12)]);
  });

  testWidgets('shows empty state action for no medications', (tester) async {
    var addCount = 0;
    await tester.pumpWidget(
      _DashboardHarness(
        medications: const [],
        onAddMedication: () async => addCount += 1,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('No medications saved yet'), findsOneWidget);
    await tester.tap(find.byKey(const Key('open-add-medication-button')));
    await tester.pump();
    expect(addCount, 1);
  });

  testWidgets(
    'shows no-schedules action for active medication without schedule',
    (tester) async {
      String? scheduledMedicationId;
      await tester.pumpWidget(
        _DashboardHarness(
          medications: [todayMedicationFixture(id: 'med-99')],
          onScheduleReminder: (medicationId) async {
            scheduledMedicationId = medicationId;
          },
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('No reminders scheduled yet'), findsOneWidget);
      await tester.tap(find.byKey(const Key('today-empty-action-noSchedules')));
      await tester.pump();
      expect(scheduledMedicationId, 'med-99');
    },
  );

  testWidgets('status semantics include medication, time, and status', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _DashboardHarness(
        medications: [todayMedicationFixture(name: 'Vitamin D')],
        schedules: [
          todayScheduleFixture(reminderTimes: [reminderTimeFixture(hour: 9)]),
        ],
        now: DateTime(2026, 5, 1, 9, 10),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.bySemanticsLabel(RegExp('Vitamin D.*9:00.*Due now')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('large text keeps handled actions reachable', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _DashboardHarness(
          medications: [todayMedicationFixture()],
          schedules: [
            todayScheduleFixture(reminderTimes: [reminderTimeFixture(hour: 9)]),
          ],
          now: DateTime(2026, 5, 1, 9, 10),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final button = find.text('Mark handled');
    expect(button, findsOneWidget);
    final size = tester.getSize(find.byType(FilledButton).last);
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('Latin American Spanish localizes dashboard statuses', (
    tester,
  ) async {
    await tester.pumpWidget(
      _DashboardHarness(
        locale: const Locale('es', '419'),
        medications: [todayMedicationFixture()],
        schedules: [
          todayScheduleFixture(reminderTimes: [reminderTimeFixture(hour: 9)]),
        ],
        now: DateTime(2026, 5, 1, 9, 10),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Toca ahora'), findsWidgets);
    expect(find.text('Marcar hecho'), findsOneWidget);
  });
}

class _DashboardHarness extends StatelessWidget {
  const _DashboardHarness({
    this.locale = const Locale('en'),
    this.medications = const [],
    this.schedules = const [],
    this.handlingRepository,
    this.scheduler,
    this.now,
    this.onAddMedication,
    this.onScheduleReminder,
  });

  final Locale locale;
  final List<Medication> medications;
  final List<ReminderSchedule> schedules;
  final FakeDailyReminderHandlingRepository? handlingRepository;
  final FakeReminderNotificationScheduler? scheduler;
  final DateTime? now;
  final Future<void> Function()? onAddMedication;
  final Future<void> Function(String? medicationId)? onScheduleReminder;

  @override
  Widget build(BuildContext context) {
    final medicationRepository = FakeMedicationRepository(medications);
    final scheduleRepository = FakeReminderScheduleRepository(schedules);
    return MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: TodayDashboardScreen(
          medicationRepository: medicationRepository,
          reminderScheduleRepository: scheduleRepository,
          dailyReminderHandlingRepository:
              handlingRepository ?? FakeDailyReminderHandlingRepository(),
          dueReminderRepository: FakeDueReminderRepository(),
          reminderNotificationScheduler:
              scheduler ?? FakeReminderNotificationScheduler(),
          notificationPermissionService: FakeNotificationPermissionService(),
          notificationStatus: SetupNotificationPermissionStatus.granted,
          onNotificationStatusChanged: (_) {},
          onAddMedication: onAddMedication ?? () async {},
          onScheduleReminder: onScheduleReminder ?? (_) async {},
          onManageMedications: () async {},
          clock: () => now ?? todayDashboardNow(hour: 9, minute: 10),
        ),
      ),
    );
  }
}
