# Quickstart: Add Medication

## Prerequisites

- Flutter SDK compatible with Dart `^3.11.5`
- Existing setup feature and localization support available

## Implementation Notes

1. Add a `features/medications` module with domain, data, and presentation layers.
2. Store medications locally as JSON behind `MedicationRepository`.
3. Do not add Firebase packages, account flows, sync, backup, analytics, or remote services in v1.
4. Add English, Spanish, and Latin American Spanish localization strings for all labels, help text, validation, duplicate confirmation, active/inactive status, privacy copy, save, and cancel actions.
5. Make add-medication reachable from the main app.
6. Keep reminder scheduling out of scope; saved active medications only need to be available as future reminder choices.

## Automated Verification

Run:

```bash
flutter test
flutter analyze
```

Required automated scenarios:

1. Saving with name only creates an active medication.
2. Saving with name, dosage label, and notes preserves entered wording.
3. Saving inactive records inactive status and displays it with text/semantics.
4. Blank or whitespace-only name prevents saving and preserves optional fields.
5. Name over 80 characters, dosage over 80 characters, and notes over 500 characters show plain-language validation.
6. Duplicate trimmed name shows confirmation and allows saving after confirmation.
7. Cancel creates no saved medication.
8. Local JSON repository persists records and reloads them offline.
9. Add-medication copy is localized in English and Latin American Spanish.
10. Large text and screen-reader tests complete without clipped text or blocked actions.

## Manual Verification

1. Disable network and add a medication successfully.
2. Confirm no account, sign-in, sync, analytics, donation, or sharing prompt appears.
3. Confirm privacy copy is visible in the add-medication flow.
4. Confirm phone and tablet layouts remain readable with large text.
5. Confirm high contrast mode preserves validation and active/inactive status meaning without color alone.
6. Confirm saved medication records appear as choices for future reminder setup when that flow is introduced.
