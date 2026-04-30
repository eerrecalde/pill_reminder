import 'package:flutter_test/flutter_test.dart';
import 'package:pill_reminder/features/medications/domain/medication.dart';
import 'package:pill_reminder/features/medications/domain/medication_entry_draft.dart';
import 'package:pill_reminder/features/medications/domain/medication_validation.dart';

import 'medication_test_fixtures.dart';

void main() {
  test('new draft defaults to active and valid draft can be created', () {
    const draft = MedicationEntryDraft(name: 'Morning pill');

    final result = MedicationValidation.validate(draft);

    expect(draft.selectedStatus, MedicationStatus.active);
    expect(result.isValid, isTrue);
  });

  test('selected inactive status is preserved in the draft', () {
    const draft = MedicationEntryDraft(
      name: 'Paused medicine',
      selectedStatus: MedicationStatus.inactive,
    );

    expect(draft.selectedStatus, MedicationStatus.inactive);
    expect(MedicationValidation.validate(draft).isValid, isTrue);
  });

  test('blank and whitespace-only names are invalid', () {
    for (final name in ['', '   ']) {
      final result = MedicationValidation.validate(
        MedicationEntryDraft(name: name),
      );

      expect(result.isValid, isFalse);
      expect(result.nameError?.issue, MedicationValidationIssue.blank);
    }
  });

  test('name, dosage label, and notes enforce field limits', () {
    final valid = MedicationValidation.validate(
      MedicationEntryDraft(
        name: _repeat('a', MedicationValidation.nameMaxLength),
        dosageLabel: _repeat('b', MedicationValidation.dosageLabelMaxLength),
        notes: _repeat('c', MedicationValidation.notesMaxLength),
      ),
    );

    expect(valid.isValid, isTrue);

    final invalid = MedicationValidation.validate(
      MedicationEntryDraft(
        name: _repeat('a', MedicationValidation.nameMaxLength + 1),
        dosageLabel: _repeat(
          'b',
          MedicationValidation.dosageLabelMaxLength + 1,
        ),
        notes: _repeat('c', MedicationValidation.notesMaxLength + 1),
      ),
    );

    expect(invalid.nameError?.issue, MedicationValidationIssue.tooLong);
    expect(invalid.dosageLabelError?.issue, MedicationValidationIssue.tooLong);
    expect(invalid.notesError?.issue, MedicationValidationIssue.tooLong);
  });

  test('duplicate names are detected after trimming', () {
    const draft = MedicationEntryDraft(name: '  Morning pill  ');

    final duplicate = MedicationValidation.hasDuplicateName(draft, [
      medicationFixture(name: 'Morning pill'),
    ]);

    expect(duplicate, isTrue);
  });
}

String _repeat(String character, int count) =>
    List.filled(count, character).join();
