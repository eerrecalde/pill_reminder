# Data Model: Add Medication

## Medication

Represents one locally stored medication record created by an older adult or caregiver.

**Fields**

- `id`: Local stable identifier generated on save. Distinguishes records even when names match.
- `name`: Required user-entered medication name, trimmed before validation and save. Maximum 80 characters.
- `dosageLabel`: Optional user-entered dosage label. Stored exactly as provided except surrounding whitespace may be trimmed. Maximum 80 characters.
- `notes`: Optional user-entered notes. Stored exactly as provided except surrounding whitespace may be trimmed. Maximum 500 characters.
- `status`: `active` or `inactive`. Defaults to `active`.
- `createdAt`: Local timestamp when the record is first saved.
- `updatedAt`: Local timestamp when the record is last changed.

**Validation Rules**

- `name` is required after trimming whitespace.
- `name` must be 80 characters or fewer.
- `dosageLabel` must be 80 characters or fewer when present.
- `notes` must be 500 characters or fewer when present.
- Duplicate names are allowed after a gentle confirmation when the trimmed name matches an existing saved medication name.
- The app must not infer dosage safety, clinical category, schedule, or medical advice from any field.

**State Transitions**

1. Draft entered -> valid save -> `Medication` created.
2. New medication defaults to `active`.
3. User-selected inactive status saves as `inactive`.
4. Saved medication remains local and available for future reminder setup.

## MedicationEntryDraft

Represents in-progress form values before save.

**Fields**

- `name`: Current name text.
- `dosageLabel`: Current optional dosage text.
- `notes`: Current optional notes text.
- `selectedStatus`: `active` or `inactive`, defaulting to `active`.
- `validationState`: Field-level validation messages for required name and length limits.
- `duplicateConfirmationState`: `notNeeded`, `required`, or `confirmed`.
- `outcome`: `editing`, `cancelled`, or `saved`.

**Validation Rules**

- Validation failure must preserve all entered optional text.
- Cancel or leaving the flow discards the unsaved draft and creates no saved medication.
- Duplicate confirmation is required only when saving a valid draft whose trimmed name matches an existing saved medication name and has not already been confirmed.

## Relationships

- A saved `Medication` can be offered as a future reminder setup choice.
- A `MedicationEntryDraft` becomes a `Medication` only after successful validation and save.
- Future Firebase user or cloud identifiers must remain optional and must not be required for local medication entry.
