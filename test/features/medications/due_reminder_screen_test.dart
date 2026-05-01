import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/presentation/due_reminder_screen.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import 'due_reminder_test_fixtures.dart';
import 'fakes/fake_due_reminder_repository.dart';
import 'fakes/fake_reminder_notification_scheduler.dart';
import 'package:pill_reminder/services/reminder_action_handler.dart';

void main() {
  testWidgets('shows medication name, scheduled time, and dosage label', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness());

    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('1 tablet'), findsOneWidget);
    expect(find.textContaining('Scheduled for'), findsOneWidget);
    expect(find.text('This reminder is due.'), findsOneWidget);
  });

  testWidgets('handles taken action and updates visible state', (tester) async {
    final repository = FakeDueReminderRepository([dueReminderFixture()]);
    await tester.pumpWidget(_Harness(repository: repository));

    await tester.tap(find.byKey(const Key('due-reminder-taken-button')));
    await tester.pumpAndSettle();

    expect(find.text('Marked as taken.'), findsOneWidget);
  });

  testWidgets('shows disabled notification guidance with actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(permissionStatus: SetupNotificationPermissionStatus.blocked),
    );

    expect(find.textContaining('device settings'), findsOneWidget);
    expect(find.byKey(const Key('due-reminder-skip-button')), findsOneWidget);
  });

  testWidgets('large text keeps actions reachable', (tester) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _Harness(),
      ),
    );

    expect(find.byKey(const Key('due-reminder-later-button')), findsOneWidget);
  });

  testWidgets('screen reader semantics include core reminder details', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_Harness());

    expect(find.text('This reminder is due.'), findsOneWidget);
    expect(find.text('Taken'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('Latin American Spanish localizes due reminder copy', (
    tester,
  ) async {
    await tester.pumpWidget(_Harness(locale: const Locale('es', '419')));

    expect(find.text('Recordatorio de medicamento'), findsOneWidget);
    expect(find.text('Este recordatorio está pendiente.'), findsOneWidget);
  });
}

class _Harness extends StatelessWidget {
  _Harness({
    FakeDueReminderRepository? repository,
    this.permissionStatus = SetupNotificationPermissionStatus.granted,
    this.locale = const Locale('en'),
  }) : repository =
           repository ?? FakeDueReminderRepository([dueReminderFixture()]);

  final FakeDueReminderRepository repository;
  final SetupNotificationPermissionStatus permissionStatus;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final reminder = dueReminderFixture();
    return MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: DueReminderScreen(
        initialReminder: reminder,
        notificationPermissionStatus: permissionStatus,
        actionHandler: ReminderActionHandler(
          repository: repository,
          notificationScheduler: FakeReminderNotificationScheduler(),
        ),
      ),
    );
  }
}
