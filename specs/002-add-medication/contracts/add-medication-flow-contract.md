# Contract: Add Medication Flow

This contract defines user-visible states and repository behavior for adding medications. It is a UI/state contract for the Flutter app, not a network API.

## Entry Conditions

- The main app provides a reachable add-medication action.
- The flow is available offline and without an account.
- Existing saved medications are loaded locally to support duplicate-name confirmation.

## Form Fields

**Medication Name**

- Required.
- Maximum 80 characters.
- Leading and trailing spaces are trimmed for validation and saved value.
- Blank or whitespace-only values prevent saving.

**Dosage Label**

- Optional.
- Maximum 80 characters.
- Stored as user-provided text without dosage safety validation.

**Notes**

- Optional.
- Maximum 500 characters.
- Supports multi-line review and editing without clipped text.

**Status**

- Active by default.
- User can select active or inactive before saving.
- Inactive status must be represented by visible text and screen-reader wording, not color alone.

## Save Behavior

- Valid draft saves a local medication record with a stable local id, created date, and updated date.
- Saved display uses the user's wording and status without inferred medical advice, schedules, or clinical classifications.
- Saved active medications are available as future reminder setup choices.
- Reminder scheduling is not part of this flow.

## Duplicate Name Behavior

- Compare the trimmed new medication name to existing saved medication names.
- If a match exists and confirmation has not occurred, show a gentle confirmation before saving.
- Confirmation copy must explain that another medication with this name already exists and the user may save anyway.
- If the user confirms, save the duplicate as a distinct medication record.
- If the user cancels confirmation, keep all draft fields intact.

## Cancel Behavior

- Cancel or leaving the flow creates no saved medication.
- Unsaved draft recovery is out of scope for v1.

## Privacy Copy

- The flow must visibly explain that medication information is stored privately on this device.
- The flow must not ask users to create an account, sign in, connect to the internet, enable sync, join analytics, donate, or share medication data.

## Accessibility and Localization

- All fields have clear labels, required/optional indications, and screen-reader-readable validation messages.
- Validation and status messages use text and semantics, not color alone.
- Primary actions use large touch targets suitable for older adults.
- Layout remains usable with large text on phones and tablets.
- All user-facing strings are available in English and Latin American Spanish.

## Repository Contract

- `MedicationRepository` provides local load/save operations for medication records.
- Repository implementation stores v1 data locally as JSON.
- Repository interface must not expose UI types or require Firebase/account concepts.
- Future Firebase implementation may add remote identifiers internally without changing the add-medication UI contract.
