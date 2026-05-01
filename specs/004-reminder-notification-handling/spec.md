# Feature Specification: Reminder Notification Handling

**Feature Branch**: `005-reminder-notification-handling`  
**Created**: 2026-05-01  
**Status**: Draft  
**Input**: User description: "Reminder Notification Handling - Create the reminder handling experience for when a medication reminder becomes due. The user should receive a clear local reminder notification with medication name, dosage label if available, and the scheduled time. From the reminder or app, the user should be able to mark the medication as taken, skip it, or be reminded again later. The app must avoid duplicate or missed reminder states when the device is offline, restarted, or notification permission changes. The experience must be understandable for older adults, accessible with screen readers and large text, and must keep medication data private on the device making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Receive a Due Reminder (Priority: P1)

An older adult or caregiver receives a clear local reminder when a scheduled
medication time becomes due, with enough information to understand which
medication is being reminded about without opening a complicated flow.

**Why this priority**: The reminder itself is the central promise of the app;
users need timely, understandable prompts for medication routines.

**Independent Test**: Can be tested by saving an active medication with a
schedule, waiting for a due time while the device is offline, and confirming the
local reminder shows the medication name, scheduled time, and dosage label when
available.

**Acceptance Scenarios**:

1. **Given** an active medication has a saved reminder schedule, **When** a scheduled reminder time becomes due, **Then** the user receives a local reminder notification.
2. **Given** a due reminder has a medication name and dosage label, **When** the notification appears, **Then** both the medication name and dosage label are visible in clear, plain language.
3. **Given** a due reminder has no dosage label, **When** the notification appears, **Then** the notification still clearly shows the medication name and scheduled time without showing a blank or confusing dosage field.
4. **Given** the device is offline at the due time, **When** the reminder becomes due, **Then** the reminder is still handled locally without requiring an account or internet connection.

---

### User Story 2 - Record What Happened (Priority: P1)

An older adult or caregiver can respond to a due medication reminder by marking
it as taken, skipping it, or choosing to be reminded again later, either from the
reminder or from inside the app.

**Why this priority**: Reminders are only useful if the user can quickly record
the outcome and avoid uncertainty about whether the dose was handled.

**Independent Test**: Can be tested by triggering a due reminder and completing
each available action from the notification and from the app, then confirming the
reminder shows one clear final state or one active remind-again-later state.

**Acceptance Scenarios**:

1. **Given** a medication reminder is due, **When** the user marks it as taken, **Then** the reminder is recorded as taken with the action time and no longer appears as unresolved.
2. **Given** a medication reminder is due, **When** the user skips it, **Then** the reminder is recorded as skipped with the action time and no longer appears as unresolved.
3. **Given** a medication reminder is due, **When** the user chooses to be reminded again later, **Then** the reminder stays pending and a later reminder is scheduled or shown according to the app's remind-again-later rule.
4. **Given** the user opens the app while a reminder is due, **When** the reminder appears in the app, **Then** the same taken, skipped, and remind-again-later choices are available in clear language.

---

### User Story 3 - Keep Reminder State Reliable (Priority: P2)

An older adult or caregiver can trust that a due reminder will not create
duplicate, contradictory, or missing states when the device is offline, restarted,
or notification permission changes.

**Why this priority**: Medication reminder history must be dependable because
unclear reminder state can cause stress and repeated or missed actions.

**Independent Test**: Can be tested by triggering reminders, restarting the
device or app, toggling notification permission, and confirming each due reminder
has one consistent state and no duplicate unresolved entries.

**Acceptance Scenarios**:

1. **Given** a reminder becomes due while the device is offline, **When** the user later opens the app, **Then** the reminder state is shown consistently without requiring network recovery.
2. **Given** the app or device restarts around a due reminder time, **When** the app opens again, **Then** the reminder is either unresolved, taken, skipped, or pending remind-again-later, with no duplicate due entries for the same medication and scheduled time.
3. **Given** notification permission is disabled before a reminder is due, **When** the user opens the app after the scheduled time, **Then** the app shows that the reminder became due and still allows taken, skipped, or remind-again-later handling.
4. **Given** notification permission is enabled after being disabled, **When** future scheduled reminders become due, **Then** the app resumes reminder delivery without duplicating reminder states already created.

---

### User Story 4 - Use an Accessible Reminder Experience (Priority: P3)

An older adult or caregiver can understand and act on due medication reminders
with large text, screen readers, large touch targets, calm copy, and localized
time formatting in English and Latin American Spanish.

**Why this priority**: Reminder handling happens at time-sensitive moments and
must remain usable for the app's primary audience.

**Independent Test**: Can be tested by receiving and responding to reminders with
large text and screen reader settings enabled in both supported language
contexts, confirming text remains readable and actions are announced clearly.

**Acceptance Scenarios**:

1. **Given** large text is enabled, **When** a due reminder is shown in the app, **Then** medication details and actions remain readable without clipped content or blocked controls.
2. **Given** a screen reader is enabled, **When** the user reviews a due reminder in the app, **Then** medication name, dosage label if present, scheduled time, current state, and available actions are announced in a logical order.
3. **Given** the app is using English or Latin American Spanish, **When** a reminder notification or in-app reminder is shown, **Then** user-visible text and scheduled times use localization-ready wording and formatting.

### Edge Cases

- The dosage label is missing; the notification and in-app reminder should omit
  dosage gracefully while still showing medication name and scheduled time.
- Notification permission is denied, blocked, revoked, or unavailable before a
  reminder is due; the app should still create and show the due reminder state
  locally when opened.
- Notification permission changes after reminders were scheduled; future
  reminders should reflect the latest permission state without duplicating
  already due reminders.
- The device is offline when a reminder becomes due or when the user responds;
  reminder state should be saved locally and remain understandable.
- The app or device restarts immediately before, during, or after a due reminder;
  each medication and scheduled time should have one consistent reminder state.
- The user taps taken and then opens the app from the same reminder; the app
  should show the reminder as taken, not unresolved.
- The user taps skip and then receives a stale notification action; the final
  state should remain clear and should not become contradictory.
- The user chooses remind again later multiple times; the app should avoid
  overlapping later reminders for the same due medication instance.
- Multiple medications are due at nearby times; each reminder should identify the
  correct medication and scheduled time without merging unrelated states.
- The user changes device language or time format; the scheduled time should keep
  the same meaning while display text follows current locale settings.
- Large text, screen readers, high contrast, or non-color-only status needs are
  present; reminder details, states, and actions should remain understandable and
  usable.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST create a due reminder instance when a saved active medication schedule reaches a scheduled reminder time.
- **FR-002**: System MUST show a local reminder notification for a due reminder when notification delivery is currently allowed.
- **FR-003**: Reminder notifications MUST include medication name, scheduled time, and dosage label when a dosage label is available.
- **FR-004**: Reminder notifications MUST omit unavailable dosage labels gracefully without showing blank, placeholder, or misleading dosage text.
- **FR-005**: Users MUST be able to mark a due reminder as taken from the notification when reminder actions are available.
- **FR-006**: Users MUST be able to skip a due reminder from the notification when reminder actions are available.
- **FR-007**: Users MUST be able to choose remind again later from the notification when reminder actions are available.
- **FR-008**: Users MUST be able to mark as taken, skip, or choose remind again later for a due reminder from inside the app.
- **FR-009**: System MUST record taken and skipped reminder outcomes with the associated medication, scheduled time, outcome type, and action time.
- **FR-010**: System MUST keep a remind-again-later reminder pending until the user marks it taken, skips it, or it becomes due again later.
- **FR-011**: System MUST prevent duplicate unresolved due reminder states for the same medication and scheduled time.
- **FR-012**: System MUST prevent contradictory final states for the same due reminder, so a reminder cannot be both taken and skipped.
- **FR-013**: System MUST keep reminder states reliable when the device is offline.
- **FR-014**: System MUST preserve due reminder states and outcomes after app restart or device restart.
- **FR-015**: System MUST reconcile notification action results with the in-app reminder view so the user sees the same current state in both places.
- **FR-016**: System MUST show due reminders in the app when notification permission is denied, blocked, revoked, unavailable, or changed after scheduling.
- **FR-017**: System MUST resume future local reminder delivery when notification permission becomes available, without recreating duplicate reminder states.
- **FR-018**: System MUST provide clear, calm notification-permission guidance when reminders cannot currently be delivered as notifications.
- **FR-019**: System MUST save reminder handling data locally on the device without requiring internet access, account creation, sign-in, remote sync, analytics participation, backup, or sharing.
- **FR-020**: System MUST keep medication names, dosage labels, schedules, reminder states, and outcomes private on the device unless a future feature explicitly adds user-approved export, backup, or sync.
- **FR-021**: System MUST provide user-visible notification text, reminder details, action labels, status messages, dates, and times in a localization-ready form for English and Latin American Spanish.
- **FR-022**: System MUST support older-adult accessibility needs throughout reminder handling, including large text, screen readers, high contrast, large touch targets, visible focus, logical reading order, and non-color-only status communication.
- **FR-023**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline for the user-facing reminder handling experience, including calm tone, readable text, generous spacing, pressure-free choices, and clear primary actions.
- **FR-024**: System MUST make reminder states understandable in plain language, including unresolved, taken, skipped, and remind-again-later states.
- **FR-025**: System MUST keep the feature scope bounded to handling due medication reminders and MUST NOT introduce clinical advice, medication safety recommendations, interaction warnings, refill tracking, accounts, remote sync, backup, or caregiver sharing.

### Key Entities *(include if feature involves data)*

- **Due Reminder**: A locally tracked reminder occurrence for one medication at one scheduled time. Key attributes are medication reference, medication name at display time, optional dosage label, scheduled time, current state, created time, and last updated time.
- **Reminder Outcome**: The user's final response to a due reminder. Key attributes are outcome type, action time, associated medication, scheduled time, and whether the outcome came from notification or in-app handling.
- **Remind Again Later Request**: A pending user choice to be reminded again for the same due reminder. Key attributes are associated due reminder, requested time window, next reminder time, and pending or resolved state.
- **Notification Permission Status**: Represents whether local reminder notifications can currently be delivered, including allowed, denied, blocked, revoked, or unavailable states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of due reminders with notification permission available show a local notification containing medication name and scheduled time in verification.
- **SC-002**: 100% of reminder notifications include the dosage label when one exists and remain clear when no dosage label exists.
- **SC-003**: At least 90% of representative older adult or caregiver test participants can mark a due reminder as taken, skip it, or choose remind again later in under 30 seconds.
- **SC-004**: 100% of taken and skipped reminder actions produce one clear final reminder state in verification.
- **SC-005**: 100% of remind-again-later actions avoid overlapping later reminders for the same medication and scheduled time in verification.
- **SC-006**: 100% of due reminders remain available with one consistent state after app restart or device restart in verification.
- **SC-007**: 100% of reminder handling actions work while the device is offline in manual verification.
- **SC-008**: 100% of reminders due while notification permission is unavailable are visible for handling inside the app when the user opens it.
- **SC-009**: At least 90% of users who encounter disabled notifications understand whether reminders can currently appear as notifications and how to continue.
- **SC-010**: 100% of user-facing reminder notification text, in-app reminder text, status messages, action labels, and time formatting are available for English and Latin American Spanish localization review.
- **SC-011**: The primary reminder handling flow can be completed with screen reader and large text enabled without clipped text, overlapping controls, inaccessible actions, or blocked outcomes.

## Assumptions

- Reminder schedules and active medications already exist from earlier features.
- Reminder handling applies to saved active medications with simple daily reminder schedules.
- A due reminder is uniquely identified by medication and scheduled reminder time, so repeated handling attempts update the same local reminder state rather than creating duplicates.
- Remind again later uses one simple, app-defined later interval suitable for older adults; choosing custom snooze durations is out of scope for this feature.
- Notification action availability may vary by device settings, but the app must always provide the same taken, skipped, and remind-again-later choices inside the app.
- Reminder outcome history remains local on the device and is not used for clinical advice or adherence scoring in this feature.
- Future schedules continue after a due reminder is taken, skipped, or reminded again later unless the schedule itself is edited or removed elsewhere.
