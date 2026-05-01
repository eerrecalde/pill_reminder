import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication_history.dart';
import 'package:pill_reminder/features/medications/presentation/medication_history_screen.dart';
import 'package:pill_reminder/l10n/app_localizations.dart';
import 'package:pill_reminder/theme/app_theme.dart';

import 'fakes/fake_medication_history_repository.dart';
import 'medication_history_test_fixtures.dart';

void main() {
  testWidgets('shows empty history state without account or sync prompts', (
    tester,
  ) async {
    await tester.pumpWidget(_HistoryHarness(entries: const []));
    await tester.pump();

    expect(find.text('No history yet'), findsOneWidget);
    expect(find.textContaining('account', findRichText: true), findsNothing);
    expect(find.textContaining('sync', findRichText: true), findsNothing);
    expect(find.textContaining('export', findRichText: true), findsNothing);
  });

  testWidgets('renders day sections, entries, times, doses, and statuses', (
    tester,
  ) async {
    await tester.pumpWidget(
      _HistoryHarness(
        entries: [
          medicationHistoryEntryFixture(
            status: MedicationHistoryStatus.snoozed,
          ),
          medicationHistoryEntryFixture(
            id: 'other',
            medicationName: 'Vitamin D',
            dosageLabel: '2 drops',
            scheduledAt: DateTime(2026, 4, 30, 9),
            status: MedicationHistoryStatus.skipped,
          ),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Medication history'), findsOneWidget);
    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('1 tablet'), findsOneWidget);
    expect(find.text('Snoozed'), findsOneWidget);
    expect(find.text('Skipped'), findsOneWidget);
  });

  testWidgets('status labels use text plus icons and wrap with large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.8)),
        child: _HistoryHarness(
          entries: [
            medicationHistoryEntryFixture(
              medicationName:
                  'Very long medication name that should wrap calmly',
              dosageLabel: 'A longer dosage label that should also wrap',
              status: MedicationHistoryStatus.missed,
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.schedule_outlined), findsOneWidget);
    expect(find.text('Missed'), findsOneWidget);
  });

  testWidgets('Spanish localizes title and status labels', (tester) async {
    await tester.pumpWidget(
      _HistoryHarness(
        locale: const Locale('es', '419'),
        entries: [
          medicationHistoryEntryFixture(status: MedicationHistoryStatus.taken),
        ],
      ),
    );
    await tester.pump();

    expect(find.text('Historial de medicamentos'), findsOneWidget);
    expect(find.text('Tomado'), findsOneWidget);
  });

  testWidgets(
    'row semantics announce day, medication, dose, time, and status',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _HistoryHarness(entries: [medicationHistoryEntryFixture()]),
      );
      await tester.pump();

      expect(
        find.bySemanticsLabel(RegExp('Aspirin.*1 tablet.*8:00.*Taken')),
        findsOneWidget,
      );
      semantics.dispose();
    },
  );
}

class _HistoryHarness extends StatelessWidget {
  const _HistoryHarness({
    required this.entries,
    this.locale = const Locale('en'),
  });

  final List<MedicationHistoryEntry> entries;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: MedicationHistoryScreen(
        repository: FakeMedicationHistoryRepository(entries),
        clock: () => DateTime(2026, 5, 1, 12),
      ),
    );
  }
}
