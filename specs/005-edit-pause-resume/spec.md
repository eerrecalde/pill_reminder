# Feature Specification: Edit, Pause, Resume

**Feature Branch**: `006-edit-pause-resume`  
**Created**: 2026-05-01  
**Status**: Draft  
**Input**: User description: "Edit, Pause, Resume - Create editing controls for medications and reminder schedules. Users should be able to change medication details, change reminder times, pause reminders temporarily, resume reminders, and delete a medication or schedule with clear confirmation. Changes must be reflected in future reminders reliably and must not create duplicate notifications. The flow should be simple enough for older adults, provide clear recovery from mistakes, work offline without an account, and include accessible, localization-ready confirmation and error states making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Edit Medication Details (Priority: P1)

An older adult or caregiver can open a saved medication, change its editable
details, review the change, and save it without changing the medication's
reminder schedule unless they choose to edit the schedule separately.

**Why this priority**: Medication names and dosage labels may need correction,
and users must be able to fix mistakes without rebuilding their reminders.

**Independent Test**: Can be fully tested by saving a medication with a reminder
schedule, editing medication details, confirming the updated details appear in
the medication list and future reminders, and confirming the existing schedule
remains intact.

**Acceptance Scenarios**:

1. **Given** a saved medication exists, **When** the user opens edit controls, **Then** the current medication details are shown in editable form.
2. **Given** the user changes medication details and saves, **When** they return to the medication list, **Then** the medication shows the updated details.
3. **Given** the edited medication has future reminders, **When** those reminders are shown, **Then** they use the updated medication details without duplicating reminder notifications.
4. **Given** the user starts editing and cancels before saving, **When** they return to the medication list, **Then** the original medication details remain unchanged.

---

### User Story 2 - Edit Reminder Times (Priority: P1)

An older adult or caregiver can change the reminder times for a saved medication
schedule, review the updated schedule, and save changes that apply only to future
reminders.

**Why this priority**: Medication routines change, and users need a trustworthy
way to adjust reminder times without receiving old and new notifications
together.

**Independent Test**: Can be fully tested by editing a saved schedule, replacing
one or more reminder times, saving, restarting the app, and confirming only the
updated future reminder times are active.

**Acceptance Scenarios**:

1. **Given** a medication has a saved reminder schedule, **When** the user edits reminder times, **Then** the current schedule is shown with existing times preselected.
2. **Given** the user changes reminder times and reviews the schedule, **When** they save, **Then** future reminders use the updated times.
3. **Given** reminder times are changed, **When** future reminders are checked, **Then** reminders from the old saved times no longer appear unless the user kept those times.
4. **Given** the user attempts to save an invalid edited schedule, **When** validation appears, **Then** valid existing choices remain available for correction.

---

### User Story 3 - Pause and Resume Reminders (Priority: P2)

An older adult or caregiver can pause reminders for a medication or schedule
temporarily, see that reminders are paused, and resume them when ready without
recreating the medication or schedule.

**Why this priority**: People may stop a medication briefly or need a quiet
period, and pausing should prevent unwanted alerts without deleting useful data.

**Independent Test**: Can be tested by pausing a medication or schedule, passing
a scheduled reminder time, confirming no notification is delivered for the
paused item, then resuming and confirming future reminder delivery continues
from the saved schedule.

**Acceptance Scenarios**:

1. **Given** a medication or schedule has active future reminders, **When** the user pauses reminders, **Then** the item is clearly shown as paused and future reminder notifications for that item stop.
2. **Given** an item is paused, **When** a scheduled reminder time passes, **Then** the app does not create a new notification for that paused item.
3. **Given** an item is paused, **When** the user resumes reminders, **Then** future reminder notifications continue using the saved schedule.
4. **Given** an item is paused, **When** the user opens the medication or schedule details, **Then** the pause state and resume action are understandable without relying on color alone.

---

### User Story 4 - Delete Medication or Schedule Safely (Priority: P2)

An older adult or caregiver can delete a medication or reminder schedule only
after a clear confirmation, with enough information to understand what will be
removed and how to recover before the action is final.

**Why this priority**: Deletion removes important reminder data and must prevent
accidental loss while still giving users control.

**Independent Test**: Can be tested by attempting to delete a schedule and a
medication, canceling from confirmation, then confirming deletion and verifying
associated future reminders are removed without duplicates or stale alerts.

**Acceptance Scenarios**:

1. **Given** the user chooses to delete a reminder schedule, **When** confirmation appears, **Then** it clearly states that reminder times for that medication will be removed while the medication remains.
2. **Given** the user chooses to delete a medication, **When** confirmation appears, **Then** it clearly states that the medication and its associated reminders will be removed.
3. **Given** the user cancels deletion, **When** they return to the previous screen, **Then** the medication or schedule remains unchanged.
4. **Given** the user confirms deletion, **When** future reminders are checked, **Then** associated pending and future notifications are removed and no stale reminders appear.

---

### User Story 5 - Use Accessible Recovery and Confirmation States (Priority: P3)

An older adult or caregiver can complete edit, pause, resume, and delete flows
with large text, screen readers, large touch targets, calm confirmation copy,
and localized text in English and Latin American Spanish.

**Why this priority**: These controls change medication reminder behavior and
must be understandable for the app's primary audience, especially when
recovering from mistakes.

**Independent Test**: Can be tested by completing each flow with large text and
screen reader settings enabled in both supported language contexts, confirming
all confirmations, errors, pause states, and destructive actions remain clear.

**Acceptance Scenarios**:

1. **Given** large text is enabled, **When** the user edits, pauses, resumes, or deletes, **Then** text and controls remain readable without clipped content or blocked actions.
2. **Given** a screen reader is enabled, **When** the user navigates confirmation and error states, **Then** medication name, schedule details, action meaning, and consequences are announced in a logical order.
3. **Given** the app is using English or Latin American Spanish, **When** confirmation, error, pause, resume, delete, and schedule text is shown, **Then** all user-visible copy and times use localization-ready wording and formatting.

### Edge Cases

- The device is offline during edit, pause, resume, or delete; the change should
  save locally and be reflected in future reminders without requiring an
  account or internet connection.
- The app or device restarts immediately after a medication detail, schedule,
  pause, resume, or delete change; the saved state should remain consistent.
- Notification permission is denied, blocked, unavailable, or changes after an
  edit; future reminder behavior should reflect the saved item state without
  creating duplicate notifications.
- The user edits medication details while reminder times stay unchanged; the
  schedule should remain active and future reminders should show the updated
  details.
- The user edits reminder times close to an upcoming reminder; the app should
  use one clear saved schedule state and avoid both old and new notifications for
  the same medication occurrence.
- The user tries to save an edited schedule with no reminder times, duplicate
  reminder times, or more than the supported daily reminder limit; saving should
  be blocked with plain-language guidance and valid choices preserved.
- The user pauses an item that already has a pending remind-again-later request;
  the pending later reminder should stop for that paused item.
- The user resumes a paused item after one or more scheduled times have passed;
  future reminders should continue from the next applicable reminder time
  without creating backfilled duplicate notifications.
- The user deletes a medication that has a saved schedule, due reminder state, or
  pending remind-again-later request; all associated future and pending reminders
  should be removed.
- The user deletes only a reminder schedule; the medication should remain saved
  and editable without reminder times.
- The user cancels a confirmation dialog or leaves an edit flow before saving;
  no saved medication, schedule, pause, resume, or delete state should change.
- Large text, screen readers, high contrast, or non-color-only status needs are
  present; edit controls, pause/resume state, confirmation dialogs, errors, and
  destructive actions should remain understandable and usable.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide edit controls for saved medications.
- **FR-002**: System MUST allow users to update medication details that appear in the medication list and future reminder messages, including medication name and dosage label when present.
- **FR-003**: System MUST preserve the medication's saved reminder schedule when medication details are edited unless the user explicitly edits or deletes the schedule.
- **FR-004**: System MUST allow users to cancel medication detail edits before saving without changing the saved medication.
- **FR-005**: System MUST provide edit controls for saved reminder schedules.
- **FR-006**: System MUST show existing reminder times when the user edits a saved schedule.
- **FR-007**: System MUST allow users to add, change, and remove reminder times in an existing schedule within the supported daily reminder limits.
- **FR-008**: System MUST provide a review or confirmation step before saving schedule edits that summarizes the updated reminder times and any continuation or stop-date information.
- **FR-009**: System MUST apply saved medication and schedule edits to future reminders reliably.
- **FR-010**: System MUST remove or replace future reminders that no longer match the saved schedule after an edit.
- **FR-011**: System MUST prevent duplicate future notifications for the same medication and scheduled time after medication edits, schedule edits, pause, resume, or delete actions.
- **FR-012**: System MUST prevent saving edited schedules with no reminder times, duplicate reminder times, or more than the supported daily reminder limit.
- **FR-013**: System MUST preserve valid medication and schedule choices when the user corrects invalid edited information.
- **FR-014**: System MUST allow users to pause reminders for a medication or its saved schedule without deleting the medication or schedule.
- **FR-015**: System MUST clearly indicate paused state wherever the medication or schedule reminder status is shown.
- **FR-016**: System MUST stop future reminder notifications and pending remind-again-later reminders for a paused medication or schedule.
- **FR-017**: System MUST allow users to resume paused reminders without recreating the medication or schedule.
- **FR-018**: System MUST resume reminders from the next applicable future reminder time and MUST NOT create duplicate notifications for reminder times that passed while paused.
- **FR-019**: System MUST allow users to delete a reminder schedule while keeping the medication saved.
- **FR-020**: System MUST allow users to delete a medication and all reminder data associated with that medication.
- **FR-021**: System MUST require clear confirmation before deleting a medication or reminder schedule.
- **FR-022**: Deletion confirmation MUST state what will be removed and what will remain, including whether the medication itself or only its reminder schedule will be deleted.
- **FR-023**: System MUST allow users to cancel deletion confirmation without changing saved data.
- **FR-024**: System MUST remove associated future reminders, pending due reminders, and pending remind-again-later requests when a medication or schedule is deleted.
- **FR-025**: System MUST save edit, pause, resume, and delete changes locally on the device without requiring internet access, account creation, sign-in, remote sync, analytics participation, backup, or sharing.
- **FR-026**: System MUST preserve saved edit, pause, resume, and delete outcomes after app restart or device restart.
- **FR-027**: System MUST communicate notification permission states when they affect whether future reminders can be delivered after an edit, pause, resume, or delete action.
- **FR-028**: System MUST provide calm, plain-language success, confirmation, cancellation, and error states for edit, pause, resume, and delete flows.
- **FR-029**: System MUST provide user-visible medication details, schedule summaries, confirmation copy, error messages, status labels, dates, and times in a localization-ready form for English and Latin American Spanish.
- **FR-030**: System MUST support older-adult accessibility needs throughout edit, pause, resume, and delete flows, including large text, screen readers, high contrast, large touch targets, visible focus, logical reading order, and non-color-only status communication.
- **FR-031**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline for user-facing edit, pause, resume, delete, confirmation, and error states, including calm tone, one decision per screen where practical, readable text, generous spacing, and pressure-free choices.
- **FR-032**: System MUST keep medication names, dosage labels, schedules, reminder states, and outcomes private on the device unless a future feature explicitly adds user-approved export, backup, or sync.
- **FR-033**: System MUST keep the feature scope bounded to editing, pausing, resuming, and deleting medications and reminder schedules and MUST NOT introduce clinical advice, medication safety recommendations, interaction warnings, refill tracking, accounts, remote sync, backup, or caregiver sharing.

### Key Entities *(include if feature involves data)*

- **Medication**: A locally saved medication record. Key attributes are medication name, optional dosage label, active or paused reminder status, associated reminder schedule, created date, last updated date, and deletion state.
- **Reminder Schedule**: A locally saved schedule for one medication. Key attributes are associated medication, daily reminder times, optional end date or indefinite continuation, active or paused state, created date, last updated date, and deletion state.
- **Reminder Time**: A user-selected time of day included in a reminder schedule. Key attributes are hour/minute meaning, localized display text, validation status, and whether it is included in the saved schedule.
- **Pause State**: The user's temporary stop state for reminders for a medication or schedule. Key attributes are associated medication or schedule, paused status, pause date, resume date when applicable, and user-visible status text.
- **Deletion Confirmation**: A user-visible confirmation before removing a medication or schedule. Key attributes are item type, item name, consequences, cancel outcome, confirm outcome, and related reminder data affected.
- **Notification Permission Status**: Represents whether local reminder notifications can currently be delivered, including granted, skipped, denied, blocked, or unavailable states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 90% of representative older adult or caregiver test participants can edit medication details and save the change in under 2 minutes on their first attempt.
- **SC-002**: At least 85% of representative test participants can edit reminder times, review the updated schedule, and save the change in under 3 minutes.
- **SC-003**: 100% of saved medication detail edits appear in medication lists and future reminder messages in verification.
- **SC-004**: 100% of saved schedule edits affect future reminders only from the updated schedule and do not leave old future notifications active in verification.
- **SC-005**: 100% of pause actions stop future reminder notifications and pending remind-again-later requests for the paused item in verification.
- **SC-006**: 100% of resume actions continue reminders from the next applicable future reminder time without backfilled duplicate notifications in verification.
- **SC-007**: 100% of confirmed medication or schedule deletions remove associated future and pending reminders, while canceled deletions leave data unchanged.
- **SC-008**: 100% of edit, pause, resume, and delete outcomes remain consistent after app restart or device restart in verification.
- **SC-009**: The edit, pause, resume, and delete flows remain fully usable while the device is offline in 100% of manual verification attempts.
- **SC-010**: 95% of validation and error attempts show readable, non-color-only guidance and allow correction without losing valid user choices.
- **SC-011**: At least 90% of users can correctly explain what will be deleted after reading the confirmation for deleting a schedule and deleting a medication.
- **SC-012**: 100% of user-facing edit, pause, resume, delete, confirmation, error, status, and time text is available for English and Latin American Spanish localization review.
- **SC-013**: The primary edit, pause, resume, and delete flows can be completed with screen reader and large text enabled without clipped text, overlapping controls, inaccessible actions, or blocked confirmation choices.

## Assumptions

- Users are editing medications and reminder schedules that already exist from earlier medication and schedule features.
- V1 reminder schedules remain simple daily schedules with the existing supported daily reminder limit and optional end date behavior.
- Pausing is a manual user-controlled state that remains in effect until the user resumes or deletes the medication or schedule.
- Editing a due reminder outcome history is out of scope; this feature changes medication details, future reminder schedules, pause/resume state, and deletion behavior.
- Deleting a medication removes its associated schedule, future reminders, due reminder states, outcomes, and pending remind-again-later requests from the device.
- Deleting only a schedule leaves the medication available without reminder times.
- Saved medication and reminder data remains on the device unless a future feature explicitly introduces backup, sync, export, or sharing with separate user consent.
- Notification permission recovery may require the user to change device settings, but edit, pause, resume, and delete flows should still save locally and explain the current delivery state clearly.
