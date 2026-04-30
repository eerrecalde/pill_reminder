import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../../l10n/app_localizations.dart';
import '../data/medication_repository.dart';
import '../domain/medication.dart';
import '../domain/medication_entry_draft.dart';
import '../domain/medication_validation.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({required this.repository, super.key});

  final MedicationRepository repository;

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();
  final _nameFocusNode = FocusNode();

  MedicationStatus _status = MedicationStatus.active;
  MedicationValidationResult _validation =
      const MedicationValidationResult.valid();
  List<Medication> _existingMedications = const [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingMedications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadExistingMedications() async {
    final medications = await widget.repository.loadMedications();
    if (!mounted) return;
    setState(() => _existingMedications = medications);
  }

  MedicationEntryDraft _currentDraft({
    DuplicateConfirmationState duplicateConfirmationState =
        DuplicateConfirmationState.notNeeded,
  }) {
    return MedicationEntryDraft(
      name: _nameController.text,
      dosageLabel: _dosageController.text,
      notes: _notesController.text,
      selectedStatus: _status,
      validationState: _validation,
      duplicateConfirmationState: duplicateConfirmationState,
    );
  }

  Future<void> _save({
    DuplicateConfirmationState duplicateConfirmationState =
        DuplicateConfirmationState.notNeeded,
  }) async {
    final l10n = AppLocalizations.of(context);
    final draft = _currentDraft(
      duplicateConfirmationState: duplicateConfirmationState,
    );
    final validation = MedicationValidation.validate(draft);
    setState(() => _validation = validation);

    if (!validation.isValid) {
      final message = _validationMessage(l10n, validation.firstError);
      if (message != null) {
        SemanticsService.sendAnnouncement(
          View.of(context),
          message,
          Directionality.of(context),
        );
      }
      _nameFocusNode.requestFocus();
      return;
    }

    if (duplicateConfirmationState != DuplicateConfirmationState.confirmed &&
        MedicationValidation.hasDuplicateName(draft, _existingMedications)) {
      final confirmed = await _confirmDuplicate(l10n);
      if (!mounted || !confirmed) return;
      await _save(
        duplicateConfirmationState: DuplicateConfirmationState.confirmed,
      );
      return;
    }

    setState(() => _saving = true);
    final medication = await widget.repository.addMedication(
      name: draft.trimmedName,
      dosageLabel: draft.trimmedDosageLabel,
      notes: draft.trimmedNotes,
      status: draft.selectedStatus,
    );
    if (!mounted) return;
    SemanticsService.sendAnnouncement(
      View.of(context),
      l10n.medicationSavedSemantics,
      Directionality.of(context),
    );
    Navigator.of(context).pop(medication);
  }

  Future<bool> _confirmDuplicate(AppLocalizations l10n) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.duplicateMedicationTitle),
            content: Text(l10n.duplicateMedicationMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.goBack),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.saveAnyway),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _cancel() {
    final l10n = AppLocalizations.of(context);
    SemanticsService.sendAnnouncement(
      View.of(context),
      l10n.medicationNotSavedSemantics,
      Directionality.of(context),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addMedicationTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PrivacyBlock(l10n: l10n),
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('medication-name-field'),
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.medicationNameLabel,
                      hintText: l10n.medicationNameHint,
                      errorText: _validationMessage(
                        l10n,
                        _validation.nameError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    key: const Key('medication-dosage-field'),
                    controller: _dosageController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.medicationDosageLabel,
                      hintText: l10n.medicationDosageHint,
                      errorText: _validationMessage(
                        l10n,
                        _validation.dosageLabelError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    key: const Key('medication-notes-field'),
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: l10n.medicationNotesLabel,
                      hintText: l10n.medicationNotesHint,
                      errorText: _validationMessage(
                        l10n,
                        _validation.notesError,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    label: l10n.medicationStatusSemantics,
                    child: SegmentedButton<MedicationStatus>(
                      segments: [
                        ButtonSegment(
                          value: MedicationStatus.active,
                          label: Text(l10n.medicationStatusActive),
                          icon: const Icon(Icons.check_circle_outline),
                        ),
                        ButtonSegment(
                          value: MedicationStatus.inactive,
                          label: Text(l10n.medicationStatusInactive),
                          icon: const Icon(Icons.pause_circle_outline),
                        ),
                      ],
                      selected: {_status},
                      onSelectionChanged: (selection) {
                        setState(() => _status = selection.single);
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    key: const Key('save-medication-button'),
                    onPressed: _saving ? null : _save,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(l10n.saveMedication),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    key: const Key('cancel-medication-button'),
                    onPressed: _saving ? null : _cancel,
                    icon: const Icon(Icons.close),
                    label: Text(l10n.cancel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validationMessage(
    AppLocalizations l10n,
    MedicationValidationError? error,
  ) {
    if (error == null) return null;
    return switch ((error.field, error.issue)) {
      (MedicationValidationField.name, MedicationValidationIssue.blank) =>
        l10n.medicationNameRequiredError,
      (MedicationValidationField.name, MedicationValidationIssue.tooLong) =>
        l10n.medicationNameTooLongError,
      (
        MedicationValidationField.dosageLabel,
        MedicationValidationIssue.tooLong,
      ) =>
        l10n.medicationDosageTooLongError,
      (MedicationValidationField.notes, MedicationValidationIssue.tooLong) =>
        l10n.medicationNotesTooLongError,
      _ => l10n.medicationValidationGenericError,
    };
  }
}

class _PrivacyBlock extends StatelessWidget {
  const _PrivacyBlock({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${l10n.addMedicationPrivacyTitle}. ${l10n.addMedicationPrivacyBody}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.addMedicationPrivacyTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.addMedicationPrivacyBody,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
