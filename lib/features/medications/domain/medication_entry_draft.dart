import 'medication.dart';
import 'medication_validation.dart';

enum DuplicateConfirmationState { notNeeded, required, confirmed }

enum MedicationDraftOutcome { editing, cancelled, saved }

class MedicationEntryDraft {
  const MedicationEntryDraft({
    this.name = '',
    this.dosageLabel = '',
    this.notes = '',
    this.selectedStatus = MedicationStatus.active,
    this.validationState = const MedicationValidationResult.valid(),
    this.duplicateConfirmationState = DuplicateConfirmationState.notNeeded,
    this.outcome = MedicationDraftOutcome.editing,
  });

  final String name;
  final String dosageLabel;
  final String notes;
  final MedicationStatus selectedStatus;
  final MedicationValidationResult validationState;
  final DuplicateConfirmationState duplicateConfirmationState;
  final MedicationDraftOutcome outcome;

  String get trimmedName => name.trim();
  String get trimmedDosageLabel => dosageLabel.trim();
  String get trimmedNotes => notes.trim();

  MedicationEntryDraft copyWith({
    String? name,
    String? dosageLabel,
    String? notes,
    MedicationStatus? selectedStatus,
    MedicationValidationResult? validationState,
    DuplicateConfirmationState? duplicateConfirmationState,
    MedicationDraftOutcome? outcome,
  }) {
    return MedicationEntryDraft(
      name: name ?? this.name,
      dosageLabel: dosageLabel ?? this.dosageLabel,
      notes: notes ?? this.notes,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      validationState: validationState ?? this.validationState,
      duplicateConfirmationState:
          duplicateConfirmationState ?? this.duplicateConfirmationState,
      outcome: outcome ?? this.outcome,
    );
  }
}
