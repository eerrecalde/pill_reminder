# Implementation Plan: Add Medication

**Branch**: `002-add-medication` | **Date**: 2026-04-29 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `specs/002-add-medication/spec.md`

## Summary

Build a calm, accessible add-medication flow for the Flutter phone/tablet app. Users can add a locally stored medication with required name, optional dosage label, optional notes, and active/inactive status. Storage will use a repository boundary with JSON persisted locally so v1 remains offline and account-free while a later Firebase-backed medication repository can be introduced without changing the presentation flow.

## Technical Context

**Language/Version**: Dart SDK `^3.11.5`, Flutter Material 3  
**Primary Dependencies**: Flutter SDK, existing localization setup, existing `shared_preferences` local storage dependency  
**Storage**: Local JSON list of medication records persisted behind a `MedicationRepository` interface; no Firebase dependency in v1  
**Testing**: `flutter test`, unit tests for validation and repository behavior, widget tests for add/cancel/duplicate/privacy/accessibility/localization flows, manual phone/tablet verification  
**Target Platform**: iOS and Android phones and tablets  
**Project Type**: Mobile app  
**Performance Goals**: Add-medication screen opens within 1 second from main app on a typical phone/tablet; save completes without perceptible delay for normal local lists; no network call is required  
**Constraints**: Offline-capable, account-free, local-first, no medical interpretation, large text, screen readers, high contrast, large touch targets, English and Latin American Spanish copy  
**Scale/Scope**: Single-device local medication list for v1; medication scheduling, medication search, import/export, accounts, sync, backup, and clinical decision support are out of scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Simplicity and clear flows**: PASS - One add-medication form with clear save/cancel, active/inactive status, privacy copy, and duplicate confirmation only when needed.
- **Accessibility for older adults**: PASS - Plan includes large text, screen-reader labels, large touch targets, non-color-only validation/status, and layout checks.
- **Reliable local-first reminders**: PASS - Medication records are local and available offline for future reminder setup; reminder scheduling remains out of scope.
- **Privacy and user control**: PASS - No account, sync, analytics, backup, donation, sharing, or remote service is introduced.
- **Maintainable architecture**: PASS - Domain validation, repository persistence, and UI are separated; repository boundary is justified by future Firebase migration.
- **Testing gate**: PASS - Automated tests cover medication data, persistence, accessibility, localization, validation, privacy, and duplicate behavior.
- **Consistent, localizable experience**: PASS - All new user-facing strings are planned for English and Latin American Spanish.
- **Measured performance**: PASS - Open/save responsiveness goals are defined and avoid background/network work.

## Project Structure

### Documentation (this feature)

```text
specs/002-add-medication/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── ux-design.md
├── contracts/
│   └── add-medication-flow-contract.md
├── checklists/
│   └── requirements.md
└── spec.md
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── medications/
│       ├── data/
│       │   ├── local_medication_repository.dart
│       │   └── medication_repository.dart
│       ├── domain/
│       │   ├── medication.dart
│       │   ├── medication_entry_draft.dart
│       │   └── medication_validation.dart
│       └── presentation/
│           ├── add_medication_screen.dart
│           ├── medication_list_section.dart
│           └── medication_status_label.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_es.arb
│   └── app_es_419.arb
└── main.dart

test/
└── features/
    └── medications/
        ├── add_medication_screen_test.dart
        ├── medication_repository_test.dart
        └── medication_validation_test.dart
```

**Structure Decision**: Use a feature-oriented `lib/features/medications/` module. Keep a repository interface for future Firebase migration, but persist v1 records as local JSON using the existing local storage dependency to avoid adding a database before medication list complexity requires it.

## Complexity Tracking

No constitution violations.

## Design Justifications

| Added Design Choice | Why Needed | Simpler Alternative Rejected Because |
|---------------------|------------|-------------------------------------|
| Medication repository interface | V1 is local JSON, but user and medication records are expected to move to Firebase later | Direct storage calls from widgets would be faster today but would couple UI to persistence and make Firebase migration harder |
| Duplicate-name confirmation | Duplicate medication names can be legitimate with different dosage/notes, but accidental duplicates are likely | Blocking duplicates would make medical assumptions; allowing duplicates silently could create mistakes |

## Phase 0: Research Summary

Research decisions are documented in [research.md](./research.md). All planning choices are resolved with local-first Flutter defaults aligned to the constitution and UX guidance.

## Phase 1: Design Summary

- Medication entities, validation rules, and state transitions are documented in [data-model.md](./data-model.md).
- UI and repository contracts are documented in [contracts/add-medication-flow-contract.md](./contracts/add-medication-flow-contract.md).
- Developer and manual verification guidance is documented in [quickstart.md](./quickstart.md).

## Post-Design Constitution Check

- **Simplicity and clear flows**: PASS - Design keeps entry to one form and one optional duplicate confirmation.
- **Accessibility for older adults**: PASS - Contract includes semantics, large text, touch targets, validation announcement, and non-color-only status.
- **Reliable local-first reminders**: PASS - Saved medications are local and available for future reminder setup.
- **Privacy and user control**: PASS - Data remains on device and no remote dependency is added.
- **Maintainable architecture**: PASS - Feature module separates domain validation, repository persistence, and presentation.
- **Testing gate**: PASS - Quickstart and contract identify automated and manual checks.
- **Consistent, localizable experience**: PASS - Localization resources are part of the implementation plan.
- **Measured performance**: PASS - Opening and saving are local operations with measurable responsiveness goals.
