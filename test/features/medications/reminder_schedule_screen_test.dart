import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/reminder_schedule.dart';
import 'package:pill_reminder/features/medications/presentation/medication_list_section.dart';
import 'package:pill_reminder/features/medications/presentation/reminder_schedule_screen.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import '../setup/fakes/fake_notification_permission_service.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';
import 'fakes/fake_reminder_schedule_repository.dart';
import 'reminder_schedule_test_fixtures.dart';

void main() {
  testWidgets('opens schedule flow from an active medication', (tester) async {
    Medication? selectedMedication;
    await tester.pumpWidget(
      _MedicationListHarness(
        medications: [activeMedicationFixture(name: 'Daily tablet')],
        onScheduleMedication: (medication) => selectedMedication = medication,
      ),
    );

    await tester.tap(find.byKey(const Key('schedule-medication-med-1')));
    await tester.pumpAndSettle();

    expect(selectedMedication?.name, 'Daily tablet');
  });

  testWidgets('reviews existing daily times and saves an indefinite schedule', (
    tester,
  ) async {
    final repository = FakeReminderScheduleRepository([
      reminderScheduleFixture(
        reminderTimes: [
          reminderTimeFixture(hour: 20),
          reminderTimeFixture(hour: 8),
        ],
      ),
    ]);
    final scheduler = FakeReminderNotificationScheduler();
    await tester.pumpWidget(
      _ScreenHarness(repository: repository, scheduler: scheduler),
    );
    await tester.pumpAndSettle();

    expect(find.text('Schedule reminders'), findsOneWidget);
    expect(find.textContaining('Aspirin'), findsWidgets);
    expect(find.textContaining('8:00'), findsWidgets);
    expect(find.textContaining('8:00'), findsWidgets);
    expect(
      find.text('Repeats every day until you edit or remove it.'),
      findsOneWidget,
    );
    expect(find.text('Reminder alerts can be delivered.'), findsOneWidget);

    await _tapSave(tester);

    expect(repository.saveCount, 2);
    expect(scheduler.scheduled, hasLength(1));
    final saved = await repository.loadScheduleForMedication('med-1');
    expect(saved?.reminderTimes.map((time) => time.hour), [8, 20]);
    expect(saved?.notificationDeliveryState, isNotNull);
  });

  testWidgets(
    'shows optional end date and cancel leaves saved schedule alone',
    (tester) async {
      final original = reminderScheduleFixture(
        reminderTimes: [
          reminderTimeFixture(hour: 18),
          reminderTimeFixture(hour: 8),
          reminderTimeFixture(hour: 12),
          reminderTimeFixture(hour: 20),
        ],
        endDate: DateTime(2026, 5, 2),
      );
      final repository = FakeReminderScheduleRepository([original]);
      await tester.pumpWidget(_ScreenHarness(repository: repository));
      await tester.pumpAndSettle();

      expect(find.textContaining('May 2, 2026'), findsWidgets);
      expect(find.textContaining('8:00'), findsWidgets);

      await _scrollTo(
        tester,
        find.byKey(const Key('cancel-reminder-schedule-button')),
      );
      await tester.tap(
        find.byKey(const Key('cancel-reminder-schedule-button')),
      );
      await tester.pumpAndSettle();

      expect(repository.saveCount, 0);
      expect(
        (await repository.loadScheduleForMedication('med-1'))?.updatedAt,
        original.updatedAt,
      );
    },
  );

  testWidgets('permission states show guidance but still allow saving', (
    tester,
  ) async {
    final cases = {
      SetupNotificationPermissionStatus.skipped:
          'Schedule saved. Reminder alerts need notifications to be enabled.',
      SetupNotificationPermissionStatus.denied:
          'Schedule saved. Reminder alerts need notifications to be enabled.',
      SetupNotificationPermissionStatus.blocked:
          'Schedule saved. Enable notifications in device settings for alerts.',
      SetupNotificationPermissionStatus.unavailable:
          'Schedule saved. Reminder alerts are not available on this device.',
    };

    for (final entry in cases.entries) {
      final repository = FakeReminderScheduleRepository([
        reminderScheduleFixture(),
      ]);
      await tester.pumpWidget(
        _ScreenHarness(
          repository: repository,
          notificationPermissionStatus: entry.key,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(entry.value), findsOneWidget);
      await _tapSave(tester);
      expect(repository.saveCount, 2);
    }
  });

  testWidgets('saved schedule becomes deliverable when permission is enabled', (
    tester,
  ) async {
    final repository = FakeReminderScheduleRepository([
      reminderScheduleFixture(
        notificationDeliveryState:
            ReminderNotificationDeliveryState.permissionNeeded,
      ),
    ]);
    await tester.pumpWidget(
      _ScreenHarness(
        repository: repository,
        notificationPermissionStatus: SetupNotificationPermissionStatus.granted,
      ),
    );
    await tester.pumpAndSettle();

    await _tapSave(tester);

    final saved = await repository.loadScheduleForMedication('med-1');
    expect(
      saved?.notificationDeliveryState,
      ReminderNotificationDeliveryState.deliverable,
    );
  });

  testWidgets('no-time validation is visible and does not save', (
    tester,
  ) async {
    final repository = FakeReminderScheduleRepository();
    await tester.pumpWidget(_ScreenHarness(repository: repository));
    await tester.pumpAndSettle();

    await _tapSave(tester);

    expect(find.text('Choose at least one reminder time.'), findsWidgets);
    expect(repository.saveCount, 0);
    expect(find.textContaining('Aspirin'), findsWidgets);
  });

  testWidgets('inactive medication guidance blocks save', (tester) async {
    final repository = FakeReminderScheduleRepository([
      reminderScheduleFixture(
        medicationId: 'med-2',
        reminderTimes: [reminderTimeFixture(hour: 8)],
      ),
    ]);
    await tester.pumpWidget(
      _ScreenHarness(
        medication: inactiveMedicationFixture(),
        repository: repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Make this medication active before scheduling reminders.'),
      findsOneWidget,
    );
    await _scrollTo(
      tester,
      find.byKey(const Key('save-reminder-schedule-button')),
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('save-reminder-schedule-button')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('validation and status use visible text, not color alone', (
    tester,
  ) async {
    final repository = FakeReminderScheduleRepository();
    await tester.pumpWidget(
      _ScreenHarness(
        repository: repository,
        notificationPermissionStatus: SetupNotificationPermissionStatus.blocked,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Schedule saved. Enable notifications in device settings for alerts.',
      ),
      findsOneWidget,
    );

    await _tapSave(tester);

    expect(
      find.byKey(const Key('schedule-validation-message')),
      findsOneWidget,
    );
    expect(find.text('Choose at least one reminder time.'), findsWidgets);
  });

  testWidgets('large text keeps review and actions reachable', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _ScreenHarness(
          repository: FakeReminderScheduleRepository([
            reminderScheduleFixture(),
          ]),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Review schedule'));
    expect(find.text('Review schedule'), findsOneWidget);
    await _scrollTo(
      tester,
      find.byKey(const Key('save-reminder-schedule-button')),
    );
    expect(find.text('Save schedule'), findsOneWidget);
    await _scrollTo(
      tester,
      find.byKey(const Key('cancel-reminder-schedule-button')),
    );
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('screen-reader labels are available for selector controls', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _ScreenHarness(
        repository: FakeReminderScheduleRepository([reminderScheduleFixture()]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel(RegExp('Reminder times')), findsWidgets);
    expect(find.bySemanticsLabel(RegExp('Reminder time 8:00')), findsWidgets);
    expect(find.byTooltip('Edit reminder time'), findsOneWidget);
    expect(find.byTooltip('Remove reminder time'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('privacy regression avoids account and remote-service prompts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ScreenHarness(
        repository: FakeReminderScheduleRepository([reminderScheduleFixture()]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('account'), findsNothing);
    expect(find.textContaining('internet'), findsNothing);
    expect(find.textContaining('sync'), findsNothing);
    expect(find.textContaining('analytics'), findsNothing);
    expect(find.textContaining('donation'), findsNothing);
    expect(find.textContaining('share'), findsNothing);
  });

  testWidgets('Latin American Spanish localizes schedule summaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ScreenHarness(
        locale: const Locale('es', '419'),
        repository: FakeReminderScheduleRepository([
          reminderScheduleFixture(endDate: DateTime(2026, 5, 2)),
        ]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Programar recordatorios'), findsOneWidget);
    expect(find.text('Revisar horario'), findsOneWidget);
    expect(find.textContaining('Termina el'), findsWidgets);
  });
}

Future<void> _tapSave(WidgetTester tester) async {
  await _scrollTo(
    tester,
    find.byKey(const Key('save-reminder-schedule-button')),
  );
  await tester.tap(find.byKey(const Key('save-reminder-schedule-button')));
  await tester.pumpAndSettle();
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  for (var attempt = 0; attempt < 10; attempt += 1) {
    if (finder.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(find.byType(ListView), const Offset(0, -260));
    await tester.pumpAndSettle();
  }
  expect(finder, findsWidgets);
}

class _ScreenHarness extends StatelessWidget {
  const _ScreenHarness({
    required this.repository,
    this.medication,
    this.scheduler,
    this.notificationPermissionStatus =
        SetupNotificationPermissionStatus.granted,
    this.locale = const Locale('en'),
  });

  final Medication? medication;
  final FakeReminderScheduleRepository repository;
  final FakeReminderNotificationScheduler? scheduler;
  final SetupNotificationPermissionStatus notificationPermissionStatus;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: ReminderScheduleScreen(
        key: ValueKey(notificationPermissionStatus),
        medication: medication ?? activeMedicationFixture(name: 'Aspirin'),
        repository: repository,
        notificationPermissionService: FakeNotificationPermissionService(
          currentStatus: notificationPermissionStatus,
        ),
        notificationScheduler: scheduler ?? FakeReminderNotificationScheduler(),
      ),
    );
  }
}

class _MedicationListHarness extends StatelessWidget {
  const _MedicationListHarness({
    required this.medications,
    required this.onScheduleMedication,
  });

  final List<Medication> medications;
  final ValueChanged<Medication> onScheduleMedication;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: MedicationListSection(
          medications: medications,
          onScheduleMedication: onScheduleMedication,
        ),
      ),
    );
  }
}
