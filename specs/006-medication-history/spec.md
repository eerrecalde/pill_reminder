# Feature Specification: Medication History

**Feature Branch**: `007-medication-history`  
**Created**: 2026-05-01  
**Status**: Draft  
**Input**: User description: "Medication History - Create a simple medication history view that helps users review whether scheduled medications were marked taken, skipped, missed, or snoozed. The history should be easy to scan by day and medication, avoid judgmental language, and remain private on the device. Users should be able to understand recent reminder activity without needing an account or internet connection. The history must support large text, screen readers, non-color-only status indicators, and localization-ready dates, times, and labels for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## Clarifications

### Session 2026-05-01

- Q: How much recent medication history should the app show? → A: Rolling 90-day history.
- Q: When should an unhandled scheduled reminder appear as missed in history? → A: More than 60 minutes after scheduled time.
- Q: Which medication details should older history entries show after edits or deletion? → A: Medication name and dosage label captured at reminder time.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review Recent Medication Activity (Priority: P1)

An older adult or caregiver can open medication history and quickly review recent scheduled medication activity grouped by day, seeing whether each recorded reminder was taken, skipped, missed, or snoozed.

**Why this priority**: The main value of the feature is helping users understand what happened recently without needing to remember every reminder.

**Independent Test**: Can be fully tested by recording several reminder outcomes across multiple days, opening history, and confirming the entries are grouped by day with medication names, scheduled times, and clear statuses.

**Acceptance Scenarios**:

1. **Given** reminder activity exists for multiple recent days, **When** the user opens medication history, **Then** entries are grouped by day in a scannable order with the most recent day first.
2. **Given** a scheduled medication reminder has a recorded outcome, **When** the user views that day in history, **Then** the medication name, scheduled time, and outcome status are shown together.
3. **Given** a day includes multiple medications or multiple scheduled times, **When** the user reviews that day, **Then** entries remain easy to compare by medication and time.
4. **Given** no reminder activity exists yet, **When** the user opens medication history, **Then** a calm empty state explains that recent reminder activity will appear after reminders occur.

---

### User Story 2 - Understand Each Status Without Judgment (Priority: P1)

An older adult or caregiver can tell whether each reminder was taken, skipped, missed, or snoozed using plain, non-judgmental language and indicators that do not rely only on color.

**Why this priority**: Medication history can feel sensitive; users need clear information without shame, blame, or hidden meaning.

**Independent Test**: Can be fully tested by creating history entries with all four statuses and confirming each one has distinct text, accessible meaning, and a non-color-only visual indicator.

**Acceptance Scenarios**:

1. **Given** a history entry was marked taken, **When** the user reviews it, **Then** the entry uses calm language such as "Taken" and shows an indicator that is distinguishable without color.
2. **Given** a history entry was marked skipped, missed, or snoozed, **When** the user reviews it, **Then** the status is clearly labeled without judgmental or alarming wording.
3. **Given** color perception is limited or high contrast is enabled, **When** the user scans history, **Then** statuses remain distinguishable through text and shape or icon cues.

---

### User Story 3 - Use History Offline and Privately (Priority: P2)

An older adult or caregiver can view recent medication history while offline and without creating an account, with history kept private on the device.

**Why this priority**: The app's reminder experience is local-first, and history contains sensitive medication behavior that should not require remote services.

**Independent Test**: Can be tested by turning off internet access, opening history, and confirming recent activity remains available locally with no account, sign-in, sync, analytics, sharing, or export requirement.

**Acceptance Scenarios**:

1. **Given** the device is offline, **When** the user opens medication history, **Then** locally recorded recent activity is still available.
2. **Given** the user has not created an account, **When** they view medication history, **Then** no sign-in, internet connection, or account prompt blocks the view.
3. **Given** history contains medication names and reminder outcomes, **When** the feature is used, **Then** that information remains on the device unless a future feature explicitly adds user-approved export, backup, or sync.

---

### User Story 4 - Review History Accessibly in Supported Languages (Priority: P2)

An older adult or caregiver can review medication history with large text, screen readers, and localized dates, times, and labels in English and Latin American Spanish.

**Why this priority**: The history must remain usable for the app's primary audience and understandable in both supported language contexts.

**Independent Test**: Can be tested by viewing history with large text and a screen reader enabled in English and Latin American Spanish, confirming content remains readable, ordered, and localized.

**Acceptance Scenarios**:

1. **Given** large text is enabled, **When** the user views medication history, **Then** day headings, medication names, times, and statuses remain readable without clipped text, overlapping controls, or blocked actions.
2. **Given** a screen reader is enabled, **When** the user navigates history, **Then** each entry announces the day, medication, scheduled time, and status in a logical order.
3. **Given** the app is using English or Latin American Spanish, **When** dates, times, section labels, statuses, and empty states appear, **Then** they use localization-ready wording and formatting.

### Edge Cases

- The device is offline, has no account, or has no internet connection; medication history should still show locally recorded recent activity.
- The app or device restarts after reminder outcomes are recorded; recent history should remain available and consistent.
- No medication history exists yet; the view should show a calm, useful empty state without implying the user did anything wrong.
- A medication is edited or deleted after history was recorded; history should keep showing the medication name and dosage label captured when the reminder occurred without exposing confusing controls for a medication that no longer exists.
- A scheduled reminder has been snoozed more than once; history should communicate the most recent understandable snooze activity without overwhelming the user.
- A reminder outcome changes from snoozed to taken, skipped, or missed; history should show a clear final status for the scheduled reminder and avoid duplicate confusing entries.
- A scheduled reminder remains unhandled more than 60 minutes after its scheduled time; history should show it as missed using the same 60-minute boundary as the current-day reminder experience.
- Multiple medications share the same scheduled time; entries should remain distinguishable by medication name and status.
- Medication names or dosage labels are long; history should preserve readability with wrapping or truncation that does not hide the status.
- Large text, screen readers, high contrast, or color vision differences are present; day grouping, status meaning, and entry order should remain usable without relying on color alone.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a medication history view reachable from the medication reminder experience.
- **FR-002**: System MUST show scheduled medication activity from the most recent 90 days grouped by day, with the most recent day shown first.
- **FR-003**: Each history entry MUST show the medication name, dosage label when captured, scheduled reminder time, and outcome status when that information is available.
- **FR-004**: System MUST support the history statuses taken, skipped, missed, and snoozed.
- **FR-005**: Status labels and supporting copy MUST use calm, non-judgmental language and MUST NOT shame, scold, or imply medical advice.
- **FR-006**: Status meaning MUST be communicated with text plus a non-color-only indicator such as an icon, shape, or label treatment.
- **FR-007**: System MUST make day groups and medication entries easy to scan by separating dates, medications, times, and statuses in a consistent order.
- **FR-008**: System MUST provide a calm empty state when no medication history is available.
- **FR-009**: System MUST record and display reminder outcomes locally on the device without requiring account creation, sign-in, internet access, remote sync, analytics participation, backup, sharing, or export.
- **FR-010**: System MUST keep medication history private on the device unless a future feature explicitly adds user-approved export, backup, or sync.
- **FR-011**: System MUST preserve recent medication history after app restart or device restart.
- **FR-012**: System MUST display history correctly when the device is offline.
- **FR-013**: System MUST avoid duplicate confusing entries for the same scheduled reminder when a snoozed reminder later becomes taken, skipped, or missed.
- **FR-014**: System MUST keep history understandable when a medication referenced by a history entry has later been edited, paused, resumed, or deleted by showing the medication name and dosage label captured when the reminder occurred.
- **FR-015**: System MUST provide user-visible history labels, status labels, empty states, dates, and times in a localization-ready form for English and Latin American Spanish.
- **FR-016**: System MUST use localization-ready date and time formatting for day headings and scheduled reminder times.
- **FR-017**: System MUST support older-adult accessibility needs throughout medication history, including large text, screen readers, high contrast, large touch targets for navigation, visible focus, logical reading order, and non-color-only status communication.
- **FR-018**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline for the history view, including calm tone, readable text, generous spacing, pressure-free choices, and avoiding clinical or technical language.
- **FR-019**: System MUST limit the default history view and retained reviewable history to a rolling 90-day window.
- **FR-020**: System MUST show an unhandled scheduled reminder as missed in history once it is more than 60 minutes past its scheduled time.
- **FR-021**: System MUST keep feature scope bounded to reviewing recent reminder activity and MUST NOT add clinical recommendations, adherence scoring, account creation, remote sync, caregiver sharing, analytics, export, backup, or editing past outcomes in v1.

### Key Entities *(include if feature involves data)*

- **Medication History Entry**: A local record of one scheduled medication reminder occurrence. Key attributes are medication reference when still available, captured medication display name, captured dosage label when present, scheduled date, scheduled time, outcome status, outcome time when known, and any snooze-related summary needed for user understanding.
- **Medication History Day Group**: A user-facing grouping of history entries for one local calendar day. Key attributes are localized day heading, entries for that day, and relative order compared with other days.
- **Reminder Outcome Status**: The user-visible result associated with a scheduled reminder. Supported values are taken, skipped, missed, and snoozed, each with a localized label and non-color-only indicator.
- **Medication Reference Snapshot**: The medication information needed to keep older history understandable if a medication is later edited or deleted. Key attributes are medication display name and optional dosage label captured at the time the reminder occurred.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 90% of representative older adult or caregiver test participants can open medication history and identify yesterday's status for a named medication in under 60 seconds.
- **SC-002**: At least 90% of representative test participants can correctly distinguish taken, skipped, missed, and snoozed entries without relying on color.
- **SC-003**: 100% of recorded reminder outcomes for the supported statuses appear in the correct day group and medication entry during verification.
- **SC-004**: 100% of medication history checks remain available while the device is offline and without account sign-in in verification.
- **SC-005**: 100% of medication history from the rolling 90-day window remains consistent after app restart or device restart in verification.
- **SC-006**: 95% of users describe the status wording as clear and non-judgmental in usability review.
- **SC-007**: 100% of user-facing history dates, times, labels, statuses, and empty states are available for English and Latin American Spanish localization review.
- **SC-008**: The history view can be completed with screen reader and large text enabled without clipped text, overlapping content, inaccessible entries, or blocked navigation in verification.
- **SC-009**: Users can scan a day with at least 8 reminder entries and identify each medication's status in under 2 minutes during usability review.

## Assumptions

- Medication history is for reviewing recent reminder activity only; changing past outcomes is out of scope for v1.
- "Recent" means a rolling 90-day history window.
- History entries are created from existing scheduled reminder outcome flows, including taken, skipped, missed, and snoozed outcomes.
- Missed history status follows the existing current-day reminder rule: an unhandled scheduled reminder becomes missed more than 60 minutes after its scheduled time.
- If a snoozed reminder later receives a final outcome, the history should favor one understandable entry for the scheduled reminder rather than showing multiple duplicate rows.
- Deleted or edited medications use the medication name and dosage label captured at the time the reminder occurred so recent history remains understandable.
- Medication history remains local to the device unless a future feature introduces explicit user-approved sharing, export, backup, or sync.
