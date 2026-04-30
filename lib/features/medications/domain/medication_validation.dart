import 'medication.dart';
import 'medication_entry_draft.dart';

class MedicationValidation {
  static const nameMaxLength = 80;
  static const dosageLabelMaxLength = 80;
  static const notesMaxLength = 500;

  static MedicationValidationResult validate(MedicationEntryDraft draft) {
    return MedicationValidationResult(
      nameError: _validateRequiredLength(
        draft.name,
        nameMaxLength,
        MedicationValidationField.name,
      ),
      dosageLabelError: _validateOptionalLength(
        draft.dosageLabel,
        dosageLabelMaxLength,
        MedicationValidationField.dosageLabel,
      ),
      notesError: _validateOptionalLength(
        draft.notes,
        notesMaxLength,
        MedicationValidationField.notes,
      ),
    );
  }

  static bool hasDuplicateName(
    MedicationEntryDraft draft,
    Iterable<Medication> existingMedications,
  ) {
    final normalizedName = draft.trimmedName.toLowerCase();
    if (normalizedName.isEmpty) return false;

    return existingMedications.any(
      (medication) => medication.name.trim().toLowerCase() == normalizedName,
    );
  }

  static MedicationValidationError? _validateRequiredLength(
    String value,
    int maxLength,
    MedicationValidationField field,
  ) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return MedicationValidationError(field, MedicationValidationIssue.blank);
    }
    if (trimmed.length > maxLength) {
      return MedicationValidationError(
        field,
        MedicationValidationIssue.tooLong,
      );
    }
    return null;
  }

  static MedicationValidationError? _validateOptionalLength(
    String value,
    int maxLength,
    MedicationValidationField field,
  ) {
    if (value.trim().length > maxLength) {
      return MedicationValidationError(
        field,
        MedicationValidationIssue.tooLong,
      );
    }
    return null;
  }
}

enum MedicationValidationField { name, dosageLabel, notes }

enum MedicationValidationIssue { blank, tooLong }

class MedicationValidationError {
  const MedicationValidationError(this.field, this.issue);

  final MedicationValidationField field;
  final MedicationValidationIssue issue;
}

class MedicationValidationResult {
  const MedicationValidationResult({
    this.nameError,
    this.dosageLabelError,
    this.notesError,
  });

  const MedicationValidationResult.valid()
    : nameError = null,
      dosageLabelError = null,
      notesError = null;

  final MedicationValidationError? nameError;
  final MedicationValidationError? dosageLabelError;
  final MedicationValidationError? notesError;

  bool get isValid =>
      nameError == null && dosageLabelError == null && notesError == null;

  MedicationValidationError? get firstError =>
      nameError ?? dosageLabelError ?? notesError;
}
