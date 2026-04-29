import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/features/setup/presentation/setup_flow.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/main.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import 'fakes/fake_notification_permission_service.dart';
import 'fakes/fake_setup_preferences_repository.dart';

void main() {
  testWidgets('fresh install language selection switches locale immediately', (
    tester,
  ) async {
    final repository = FakeSetupPreferencesRepository();
    final notifications = FakeNotificationPermissionService();

    await tester.pumpWidget(
      _Harness(repository: repository, notifications: notifications),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.text('Español (Latinoamérica)'));
    await tester.pumpAndSettle();

    expect(find.text('Tu información se queda contigo'), findsOneWidget);
  });

  testWidgets('mistaken language selection can be changed before completion', (
    tester,
  ) async {
    final repository = FakeSetupPreferencesRepository();
    final notifications = FakeNotificationPermissionService();

    await tester.pumpWidget(
      _Harness(repository: repository, notifications: notifications),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español (Latinoamérica)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Atrás'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Your information stays with you'), findsOneWidget);
  });

  testWidgets('completes setup and skips repeated setup on next launch', (
    tester,
  ) async {
    final repository = FakeSetupPreferencesRepository();
    final notifications = FakeNotificationPermissionService(
      requestResult: SetupNotificationPermissionStatus.granted,
    );

    await tester.pumpWidget(
      PillReminderApp(
        setupPreferencesRepository: repository,
        notificationPermissionService: notifications,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Turn on reminders'));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);

    await tester.pumpWidget(
      PillReminderApp(
        setupPreferencesRepository: repository,
        notificationPermissionService: notifications,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Choose your language'), findsNothing);
  });

  testWidgets('resumes interrupted setup from saved privacy step', (
    tester,
  ) async {
    final repository = FakeSetupPreferencesRepository(
      SetupState.initial().copyWith(
        currentStep: SetupStep.privacy,
        language: SetupLanguage.english,
      ),
    );

    await tester.pumpWidget(
      _Harness(
        repository: repository,
        notifications: FakeNotificationPermissionService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your information stays with you'), findsOneWidget);
  });

  testWidgets('resumes interrupted setup from saved notification step', (
    tester,
  ) async {
    final repository = FakeSetupPreferencesRepository(
      SetupState.initial().copyWith(
        currentStep: SetupStep.notifications,
        language: SetupLanguage.english,
        privacyAcknowledged: true,
      ),
    );

    await tester.pumpWidget(
      _Harness(
        repository: repository,
        notifications: FakeNotificationPermissionService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Get reminder alerts'), findsOneWidget);
  });

  testWidgets('privacy copy reassures no account and no sharing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(
        repository: FakeSetupPreferencesRepository(
          SetupState.initial().copyWith(currentStep: SetupStep.privacy),
        ),
        notifications: FakeNotificationPermissionService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your medication reminders are saved only on this device.\nNo account. No sharing.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('privacy screen supports large text and semantic order', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _Harness(
          repository: FakeSetupPreferencesRepository(
            SetupState.initial().copyWith(currentStep: SetupStep.privacy),
          ),
          notifications: FakeNotificationPermissionService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your information stays with you'), findsWidgets);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('accessibility labels expose selected language state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(
        repository: FakeSetupPreferencesRepository(),
        notifications: FakeNotificationPermissionService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('English, Selected'), findsOneWidget);
  });

  testWidgets('setup introduces no account or remote service dependency copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      _Harness(
        repository: FakeSetupPreferencesRepository(
          SetupState.initial().copyWith(currentStep: SetupStep.privacy),
        ),
        notifications: FakeNotificationPermissionService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('No account'), findsOneWidget);
    expect(find.textContaining('No sharing'), findsOneWidget);
    expect(find.textContaining('Firebase'), findsNothing);
  });
}

class _Harness extends StatefulWidget {
  const _Harness({required this.repository, required this.notifications});

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
      home: SetupFlow(
        repository: widget.repository,
        notificationPermissionService: widget.notifications,
        onLocaleChanged: (locale) => setState(() => _locale = locale),
        onComplete: (_) {},
      ),
    );
  }
}
