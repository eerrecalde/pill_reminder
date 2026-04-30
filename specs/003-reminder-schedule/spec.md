# Feature Specification: Reminder Schedule

**Feature Branch**: `003-reminder-schedule`  
**Created**: 2026-04-30  
**Status**: Draft  
**Input**: User description: "Reminder Schedule - Create the reminder schedule flow for a medication. Users should be able to choose simple reminder times for a medication, including one or more times per day, and save the schedule without needing an account or internet connection. The flow should prioritize common daily medication routines and avoid complex recurrence rules in the first version. Users must be able to review the selected schedule before saving, understand when reminders will happen, and recover from invalid or incomplete choices. The schedule must be reliable after app restart, support notification-permission edge cases, and remain usable with large text, screen readers, large touch targets, and localization-ready date and time formatting for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Schedule Daily Reminder Times (Priority: P1)

An older adult or caregiver can choose a medication, select one or more daily
reminder times, review the schedule in plain language, and save it for reliable
daily reminders.

**Why this priority**: Reminder schedules are the core value of the app after a
medication exists; users need a clear way to say when reminders should happen.

**Independent Test**: Can be fully tested by choosing a medication, selecting
one or more reminder times for each day, reviewing the summary, saving, and
confirming the same schedule is available after closing and reopening the app.

**Acceptance Scenarios**:

1. **Given** the user has a saved active medication, **When** they open reminder scheduling for that medication, **Then** they can add at least one daily reminder time.
2. **Given** the user has selected multiple daily reminder times, **When** they review the schedule, **Then** the flow lists each time in a clear daily summary before saving.
3. **Given** the user saves a valid schedule, **When** the app is closed and reopened, **Then** the saved medication schedule is still present and understandable.
4. **Given** the device is offline and no account is signed in, **When** the user saves a valid schedule, **Then** the schedule is saved locally on the device.

---

### User Story 2 - Understand Reminder Availability (Priority: P2)

An older adult or caregiver can understand whether reminders can currently be
delivered and what to do if notification permission is skipped, denied, blocked,
or unavailable.

**Why this priority**: A saved schedule is only useful if users understand the
relationship between the schedule and reminder alerts.

**Independent Test**: Can be tested by scheduling with notifications available,
skipped, denied, blocked, and unavailable, then confirming the flow explains the
delivery state without blocking schedule saving.

**Acceptance Scenarios**:

1. **Given** notification permission is available, **When** the user reviews the schedule, **Then** the flow explains that reminders will use the selected times.
2. **Given** notification permission is skipped, denied, blocked, or unavailable, **When** the user reviews or saves the schedule, **Then** the flow explains that the schedule is saved but reminder alerts cannot be delivered until notifications are enabled.
3. **Given** reminders cannot currently be delivered, **When** the user saves the schedule, **Then** saving is not blocked and the user sees a calm recovery path.

---

### User Story 3 - Recover From Incomplete or Invalid Choices (Priority: P2)

An older adult or caregiver receives clear guidance when required schedule
choices are missing, duplicated, or hard to understand, and can correct the
schedule without losing valid selections.

**Why this priority**: Scheduling mistakes can create missed or confusing
reminders, so recovery needs to be gentle and precise.

**Independent Test**: Can be tested by attempting to save without any reminder
time, adding duplicate times, editing selections, and confirming valid choices
remain intact during correction.

**Acceptance Scenarios**:

1. **Given** no reminder time is selected, **When** the user tries to continue or save, **Then** the flow prevents saving and explains that at least one time is needed.
2. **Given** the user adds the same time more than once for the same medication schedule, **When** the duplicate is detected, **Then** the flow explains the duplicate and helps the user keep only one instance.
3. **Given** the user corrects an invalid schedule, **When** they return to review, **Then** previously valid times remain selected.

---

### User Story 4 - Use an Accessible, Calm Schedule Flow (Priority: P3)

An older adult or caregiver can complete the reminder schedule flow using large
text, screen readers, large touch targets, and localized date and time formats in
English or Latin American Spanish.

**Why this priority**: The schedule flow affects a high-frequency medication
task and must stay usable for the app's primary audience.

**Independent Test**: Can be tested by completing the schedule flow with large
text and screen reader navigation in both supported language contexts, confirming
all controls, summaries, validation messages, and notification states remain
usable and understandable.

**Acceptance Scenarios**:

1. **Given** large text is enabled, **When** the user selects and reviews reminder times, **Then** text and controls remain readable without clipped content or blocked actions.
2. **Given** a screen reader is enabled, **When** the user navigates the flow, **Then** medication name, selected times, actions, errors, and notification state are announced in a logical order.
3. **Given** the app is using English or Latin American Spanish, **When** reminder times and schedule summaries are shown, **Then** user-visible dates and times use localization-ready formatting.

### Edge Cases

- The user opens scheduling for a medication that is inactive; the flow should
  explain that inactive medications are not ready for reminders and avoid saving
  an active reminder schedule without a deliberate status change.
- The user tries to save without selecting any reminder time; saving should be
  blocked with plain-language guidance.
- The user selects the same time more than once; the flow should prevent duplicate
  reminders for the same medication at the same daily time.
- The user adds several daily times; the review summary should remain readable
  and sorted in the order reminders will occur.
- The user changes, removes, or reorders reminder times before saving; the final
  reviewed schedule should match what is saved.
- The device is offline throughout scheduling; the flow should still complete
  because no account or remote connection is required.
- The app restarts after saving; the schedule should remain available and show
  the same selected times and delivery state.
- Notification permission is skipped, denied, blocked, or unavailable; the
  schedule should still save, but the user should understand reminder alerts
  cannot be delivered until permission is enabled.
- The user changes device time format or language; saved schedule times should
  remain semantically the same while display formatting follows the user's
  locale settings.
- Large text, screen readers, high contrast, or non-color-only status needs are
  present; all schedule choices, review summaries, validation messages, and
  notification states should remain understandable and usable.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a reminder schedule flow for a saved medication.
- **FR-002**: System MUST allow users to select one or more reminder times per day for a medication.
- **FR-003**: System MUST limit v1 scheduling to simple daily reminder times and MUST NOT require users to configure complex recurrence rules.
- **FR-004**: System MUST allow users to add, edit, and remove selected reminder times before saving.
- **FR-005**: System MUST present a review step that summarizes the medication and all selected reminder times before saving.
- **FR-006**: System MUST describe saved schedules in plain language so users can understand when reminders will happen.
- **FR-007**: System MUST prevent saving a schedule with no reminder times selected.
- **FR-008**: System MUST prevent duplicate reminder times for the same medication schedule.
- **FR-009**: System MUST preserve valid selected times when the user corrects invalid or incomplete schedule choices.
- **FR-010**: System MUST save valid reminder schedules locally on the device without requiring internet access.
- **FR-011**: System MUST NOT require account creation, sign-in, remote sync, analytics participation, or an internet connection to create or save a reminder schedule.
- **FR-012**: System MUST keep medication and schedule data private by default and document any storage, retention, deletion, sharing, backup, analytics, donation, or remote-service behavior introduced by this feature.
- **FR-013**: System MUST preserve saved reminder schedules after app restart.
- **FR-014**: System MUST communicate notification permission state during scheduling and review when it affects whether reminder alerts can be delivered.
- **FR-015**: System MUST allow users to save a schedule even when notification permission is skipped, denied, blocked, or unavailable, while clearly explaining that reminder alerts cannot be delivered until notifications are enabled.
- **FR-016**: System MUST provide a calm recovery path for skipped, denied, blocked, or unavailable notification permission states.
- **FR-017**: System MUST provide validation messages in plain language and communicate them with text and screen-reader announcement, not color alone.
- **FR-018**: System MUST provide user-visible copy, reminder time text, schedule summaries, notification guidance, dates, times, and error states in a localization-ready form for English and Latin American Spanish.
- **FR-019**: System MUST support older-adult accessibility needs throughout the schedule flow, including large text, screen readers, high contrast, large touch targets, visible focus, clear navigation, and non-color-only status communication.
- **FR-020**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline for the user-facing schedule flow, including calm tone, one decision per screen where practical, 48px minimum touch targets with 56px preferred primary actions, descriptive labels, logical reading order, and pressure-free choices.
- **FR-021**: System MUST allow users to cancel or leave the schedule flow before saving without creating or changing a saved reminder schedule.
- **FR-022**: System MUST keep the schedule scope bounded to daily medication reminders and MUST NOT introduce dosage safety advice, clinical recommendations, medication interaction warnings, refill tracking, custom recurrence rules, accounts, backup, or sync as part of this feature.

### Key Entities *(include if feature involves data)*

- **Reminder Schedule**: A locally stored user-created schedule for one medication. Key attributes are the associated medication, selected daily reminder times, notification delivery state, created date, last updated date, and saved/unsaved status.
- **Reminder Time**: A user-selected time of day when a medication reminder should happen. Key attributes are hour/minute meaning, localized display text, duplicate status, and whether it is included in the current schedule review.
- **Schedule Review**: The user-visible summary shown before saving. Key attributes are medication name, ordered reminder times, notification permission message, validation state, and save/cancel outcome.
- **Notification Permission Status**: Represents whether reminder alerts can currently be delivered, including granted, skipped, denied, blocked, or unavailable states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 90% of representative older adult or caregiver test participants can create a valid daily reminder schedule with one medication and one reminder time in under 2 minutes on their first attempt.
- **SC-002**: At least 85% of representative test participants can create and review a schedule with multiple daily reminder times in under 3 minutes.
- **SC-003**: 95% of validation attempts with no selected reminder time or duplicate times show a readable, non-color-only message and allow correction without losing valid selected times.
- **SC-004**: 100% of valid saved schedules remain available with the same medication and selected daily times after app restart in verification.
- **SC-005**: The schedule flow remains fully usable while the device is offline in 100% of manual verification attempts.
- **SC-006**: At least 90% of users who save while notifications are unavailable understand that the schedule is saved but reminder alerts require notification permission.
- **SC-007**: 100% of user-facing schedule text, reminder time formatting, notification guidance, validation messages, and review summaries are available for English and Latin American Spanish localization review.
- **SC-008**: The primary schedule flow can be completed with screen reader and large text enabled without clipped text, overlapping controls, inaccessible time choices, or blocked save/cancel actions.
- **SC-009**: 100% of schedule review summaries list selected reminder times in the order reminders will happen.

## Assumptions

- Users schedule reminders for medications that already exist in the local medication list.
- V1 reminder schedules repeat every day at the selected times; weekly, monthly, interval-based, as-needed, tapering, and date-range schedules are out of scope.
- A medication can have one saved daily reminder schedule in this feature; editing or replacing that schedule is allowed through the same flow.
- A practical v1 schedule supports a small set of daily times suitable for common routines, such as morning, midday, evening, and bedtime.
- Notification permission recovery may require the user to change device settings, but the schedule flow only needs to guide the user clearly and allow saving.
- Saved schedule data remains on the device unless a future feature explicitly introduces backup, sync, export, or sharing with separate user consent.
- Reminder scheduling does not include dosage safety checks, clinical warnings, or confirmation that the medication was taken.
