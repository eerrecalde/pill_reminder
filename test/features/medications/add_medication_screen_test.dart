import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/presentation/add_medication_screen.dart';
import 'package:pill_reminder/features/medications/presentation/medication_list_section.dart';
import 'package:pill_reminder/features/setup/domain/notification_permission_status.dart';
import 'package:pill_reminder/features/setup/domain/setup_language.dart';
import 'package:pill_reminder/features/setup/domain/setup_state.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/main.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import '../setup/fakes/fake_notification_permission_service.dart';
import '../setup/fakes/fake_setup_preferences_repository.dart';
import 'fakes/fake_medication_repository.dart';
import 'medication_test_fixtures.dart';

void main() {
  testWidgets('adds an active medication from the main app', (tester) async {
    final repository = FakeMedicationRepository();

    await tester.pumpWidget(
      PillReminderApp(
        setupPreferencesRepository: FakeSetupPreferencesRepository(
          SetupState(
            language: SetupLanguage.english,
            currentStep: SetupStep.complete,
            privacyAcknowledged: true,
            notificationStatus: SetupNotificationPermissionStatus.granted,
            isComplete: true,
          ),
        ),
        notificationPermissionService: FakeNotificationPermissionService(),
        medicationRepository: repository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open-add-medication-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('medication-name-field')),
      'Morning pill',
    );
    await tester.enterText(
      find.byKey(const Key('medication-dosage-field')),
      '1 tablet',
    );
    await tester.enterText(
      find.byKey(const Key('medication-notes-field')),
      'Take after breakfast',
    );
    await _tapSave(tester);
    await tester.pumpAndSettle();

    expect(find.text('Morning pill'), findsOneWidget);
    expect(find.text('1 tablet'), findsOneWidget);
    expect(find.text('Take after breakfast'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(repository.saveCount, 1);
  });

  testWidgets('duplicate name shows confirmation and saves after confirm', (
    tester,
  ) async {
    final repository = FakeMedicationRepository([
      medicationFixture(name: 'Morning pill'),
    ]);
    await tester.pumpWidget(_ScreenHarness(repository: repository));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('medication-name-field')),
      '  Morning pill  ',
    );
    await _tapSave(tester);
    await tester.pumpAndSettle();

    expect(find.text('This name is already saved'), findsOneWidget);
    expect(repository.saveCount, 0);

    await tester.tap(find.text('Save anyway'));
    await tester.pumpAndSettle();

    expect(repository.saveCount, 1);
    expect((await repository.loadMedications()).last.name, 'Morning pill');
  });

  testWidgets('privacy copy is visible and avoids account or remote prompts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ScreenHarness(repository: FakeMedicationRepository()),
    );

    expect(find.text('Your medication stays on this device'), findsOneWidget);
    expect(
      find.text('No account or internet is needed to add it.'),
      findsOneWidget,
    );
    expect(find.textContaining('Firebase'), findsNothing);
    expect(find.textContaining('sync'), findsNothing);
    expect(find.textContaining('analytics'), findsNothing);
    expect(find.textContaining('donation'), findsNothing);
  });

  testWidgets('privacy copy is localized for Latin American Spanish', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ScreenHarness(
        repository: FakeMedicationRepository(),
        locale: const Locale('es', '419'),
      ),
    );

    expect(
      find.text('Tu medicamento se queda en este dispositivo'),
      findsOneWidget,
    );
    expect(
      find.text('No necesitas cuenta ni internet para agregarlo.'),
      findsOneWidget,
    );
  });

  testWidgets('inactive status can be selected and saved', (tester) async {
    final repository = FakeMedicationRepository();
    await tester.pumpWidget(_ScreenHarness(repository: repository));

    await tester.enterText(
      find.byKey(const Key('medication-name-field')),
      'Paused medicine',
    );
    await tester.tap(find.text('Inactive'));
    await _tapSave(tester);

    final medications = await repository.loadMedications();
    expect(medications.single.status, MedicationStatus.inactive);
  });

  testWidgets('inactive status uses visible text and semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ListHarness([
        medicationFixture(
          name: 'Paused medicine',
          status: MedicationStatus.inactive,
        ),
      ]),
    );

    expect(find.text('Inactive'), findsOneWidget);
    expect(find.bySemanticsLabel('Status, inactive'), findsOneWidget);
  });

  testWidgets('missing-name validation preserves optional fields', (
    tester,
  ) async {
    final repository = FakeMedicationRepository();
    await tester.pumpWidget(_ScreenHarness(repository: repository));

    await tester.enterText(
      find.byKey(const Key('medication-dosage-field')),
      '1 tablet',
    );
    await tester.enterText(
      find.byKey(const Key('medication-notes-field')),
      'Take with food',
    );
    await _tapSave(tester);
    await tester.pumpAndSettle();

    expect(find.text('Enter a medication name.'), findsOneWidget);
    expect(find.text('1 tablet'), findsOneWidget);
    expect(find.text('Take with food'), findsOneWidget);
    expect(repository.saveCount, 0);
  });

  testWidgets('field length validation uses plain text errors', (tester) async {
    await tester.pumpWidget(
      _ScreenHarness(repository: FakeMedicationRepository()),
    );

    await tester.enterText(
      find.byKey(const Key('medication-name-field')),
      _repeat('a', 81),
    );
    await tester.enterText(
      find.byKey(const Key('medication-dosage-field')),
      _repeat('b', 81),
    );
    await tester.enterText(
      find.byKey(const Key('medication-notes-field')),
      _repeat('c', 501),
    );
    await _tapSave(tester);
    await tester.pumpAndSettle();

    expect(
      find.text('Use 80 characters or fewer for the medication name.'),
      findsOneWidget,
    );
    expect(
      find.text('Use 80 characters or fewer for the dosage label.'),
      findsOneWidget,
    );
    expect(find.text('Use 500 characters or fewer for notes.'), findsOneWidget);
  });

  testWidgets('cancel exits without saving', (tester) async {
    final repository = FakeMedicationRepository();
    await tester.pumpWidget(_ScreenHarness(repository: repository));

    await tester.enterText(
      find.byKey(const Key('medication-name-field')),
      'Cancel me',
    );
    await _scrollTo(tester, find.byKey(const Key('cancel-medication-button')));
    await tester.tap(find.byKey(const Key('cancel-medication-button')));
    await tester.pumpAndSettle();

    expect(repository.saveCount, 0);
  });

  testWidgets('large text keeps primary add-medication actions available', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _ScreenHarness(repository: FakeMedicationRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Medication name (required)'), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('save-medication-button')));
    expect(find.text('Save medication'), findsOneWidget);
    await _scrollTo(tester, find.byKey(const Key('cancel-medication-button')));
    expect(find.text('Cancel'), findsOneWidget);
  });
}

Future<void> _tapSave(WidgetTester tester) async {
  await _scrollTo(tester, find.byKey(const Key('save-medication-button')));
  await tester.tap(find.byKey(const Key('save-medication-button')));
  await tester.pumpAndSettle();
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    -260,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();
}

String _repeat(String character, int count) =>
    List.filled(count, character).join();

class _ScreenHarness extends StatelessWidget {
  const _ScreenHarness({
    required this.repository,
    this.locale = const Locale('en'),
  });

  final FakeMedicationRepository repository;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: AddMedicationScreen(repository: repository),
    );
  }
}

class _ListHarness extends StatelessWidget {
  const _ListHarness(this.medications);

  final List<Medication> medications;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: MedicationListSection(medications: medications)),
    );
  }
}
