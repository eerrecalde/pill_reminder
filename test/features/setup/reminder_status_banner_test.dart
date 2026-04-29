import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/features/setup/presentation/reminder_status_banner.dart';
import 'package:pill_reminder/features/setup/presentation/setup_preferences_screen.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import 'fakes/fake_notification_permission_service.dart';
import 'fakes/fake_setup_preferences_repository.dart';

void main() {
  testWidgets('granted notification status hides reminder status', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Localized(
        child: ReminderStatusBanner(
          status: SetupNotificationPermissionStatus.granted,
          notificationPermissionService: FakeNotificationPermissionService(),
          onStatusChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Reminder alerts are off'), findsNothing);
  });

  testWidgets(
    'skipped notification status shows non-blocking reminder status',
    (tester) async {
      await tester.pumpWidget(
        _Localized(
          child: ReminderStatusBanner(
            status: SetupNotificationPermissionStatus.skipped,
            notificationPermissionService: FakeNotificationPermissionService(),
            onStatusChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Reminder alerts are off'), findsOneWidget);
      expect(
        find.text(
          'Reminders cannot be delivered until notifications are enabled.',
        ),
        findsOneWidget,
      );
      expect(find.text('Open settings'), findsOneWidget);
    },
  );

  testWidgets('denied notification status can open recovery guidance', (
    tester,
  ) async {
    final notifications = FakeNotificationPermissionService(
      currentStatus: SetupNotificationPermissionStatus.granted,
    );
    SetupNotificationPermissionStatus? changed;

    await tester.pumpWidget(
      _Localized(
        child: ReminderStatusBanner(
          status: SetupNotificationPermissionStatus.denied,
          notificationPermissionService: notifications,
          onStatusChanged: (status) => changed = status,
        ),
      ),
    );

    await tester.tap(find.text('Open settings'));
    await tester.pumpAndSettle();

    expect(notifications.openedSettings, isTrue);
    expect(changed, SetupNotificationPermissionStatus.granted);
  });

  testWidgets('setup preferences show post-setup notification guidance', (
    tester,
  ) async {
    final state = SetupState.initial().copyWith(
      isComplete: true,
      privacyAcknowledged: true,
      currentStep: SetupStep.complete,
      notificationStatus: SetupNotificationPermissionStatus.denied,
    );

    await tester.pumpWidget(
      _Localized(
        child: SetupPreferencesScreen(
          repository: FakeSetupPreferencesRepository(state),
          notificationPermissionService: FakeNotificationPermissionService(),
          initialState: state,
          onLocaleChanged: (_) {},
          onStateChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Setup preferences'), findsOneWidget);
    expect(find.text('Reminder alerts are off'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
  });
}

class _Localized extends StatelessWidget {
  const _Localized({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: child),
    );
  }
}
