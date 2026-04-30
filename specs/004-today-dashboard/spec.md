# Feature Specification: Today Dashboard

**Feature Branch**: `004-today-dashboard`  
**Created**: 2026-04-30  
**Status**: Draft  
**Input**: User description: "Today Dashboard - Create the main today view for the pill reminder app. The view should show the user's medications and reminders for the current day in a clear, readable order, emphasizing what is due now, what is upcoming, and what has already been handled. Users should be able to quickly understand their day without opening multiple screens. Empty states should help new users add their first medication or reminder. Status must not rely on color alone, and the screen must support large text, screen readers, high contrast, large touch targets, and localization-ready copy for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## Clarifications

### Session 2026-04-30

- Q: Should users be able to mark reminders as handled directly from the Today Dashboard? → A: Users can mark due or upcoming reminders as handled from the dashboard.
- Q: What time window should define a reminder as due now? → A: A reminder is due now from its scheduled time until 60 minutes after.
- Q: What happens to today's alert if an upcoming reminder is marked handled before its scheduled time? → A: Suppress today's alert for that reminder.
- Q: How should reminders over 60 minutes late be shown? → A: Show reminders over 60 minutes late as missed until handled.
- Q: Should the Today Dashboard replace the current main medication list as the landing view? → A: The Today Dashboard becomes the landing view, with medication management reachable from it.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See Today's Medication Plan (Priority: P1)

As a user with saved medications and reminder schedules, I want the main view to show today's reminders in a readable order so I can quickly understand what needs attention now, what is coming later, and what has already been handled.

**Why this priority**: This is the core value of the dashboard. Without a clear daily view, users must inspect multiple screens to understand their medication day.

**Independent Test**: Can be tested by opening the app on a day with active medications and reminders due in the past, near present, and future, then confirming the dashboard groups and orders them clearly.

**Acceptance Scenarios**:

1. **Given** the user has active medications with reminder times today, **When** the user opens the app, **Then** the today view lists today's reminder items in chronological order with clear labels for due now, upcoming, missed, and handled reminders.
2. **Given** at least one reminder is due now, **When** the user views the dashboard, **Then** the due-now reminder is visually and textually emphasized before lower-priority upcoming or handled content.
3. **Given** the user has handled a reminder earlier today, **When** the dashboard is shown, **Then** that reminder remains visible as handled and does not appear as still due.
4. **Given** a reminder is due or upcoming today, **When** the user marks it as handled from the dashboard, **Then** the reminder moves to the handled state without requiring another screen.

---

### User Story 2 - Understand Empty And Partial Days (Priority: P2)

As a new or partially set-up user, I want the today view to explain why there is nothing due and guide me to add medications or reminders so I know what to do next.

**Why this priority**: Empty states are common during first use and after adding medications without schedules. Helpful guidance prevents the main screen from feeling broken or confusing.

**Independent Test**: Can be tested by opening the app with no medications, with medications but no reminder schedules, and with no reminders remaining today.

**Acceptance Scenarios**:

1. **Given** the user has no saved medications, **When** the user opens the today view, **Then** the screen explains that no medications are saved yet and offers a clear action to add the first medication.
2. **Given** the user has medications but no reminder schedules, **When** the user opens the today view, **Then** the screen explains that no reminders are scheduled yet and offers a clear action to add or schedule a reminder.
3. **Given** all of today's reminders have been handled or there are no more reminders today, **When** the user opens the dashboard, **Then** the screen communicates that the rest of today is clear without implying the user has no medications.

---

### User Story 3 - Review Status Accessibly (Priority: P3)

As a user who relies on large text, high contrast, screen readers, or non-color cues, I want medication and reminder statuses to be understandable without relying on color alone so I can safely use the dashboard.

**Why this priority**: The dashboard is the primary daily safety surface, so status must remain clear across accessibility settings and assistive technology.

**Independent Test**: Can be tested by opening the dashboard with large text, screen reader navigation, high contrast settings, and multiple reminder statuses, then verifying all statuses and actions remain readable, labeled, and reachable.

**Acceptance Scenarios**:

1. **Given** the user has due, upcoming, missed, and handled reminders, **When** the screen is viewed without color perception, **Then** each status is still communicated using text and/or icons with accessible labels.
2. **Given** large text is enabled, **When** the dashboard is viewed, **Then** reminder cards, section headers, and actions remain readable without clipped text or overlapping controls.
3. **Given** a screen reader is active, **When** the user navigates the dashboard, **Then** reminder items are announced in a logical order with medication name, reminder time, and status.

### Edge Cases

- The user has no medications saved.
- The user has medications saved but none are active.
- The user has active medications without reminder schedules.
- A medication has multiple reminder times today.
- Multiple medications have reminders at the same time.
- A reminder time has passed but has not yet been handled.
- A reminder is more than 60 minutes past its scheduled time and has not been handled.
- All reminders for today have already been handled.
- The device is offline, restarted, or has notification permissions denied.
- The current date changes while the app remains open.
- Large text, screen readers, high contrast, and non-color-only status indicators are enabled.
- Localized English or Latin American Spanish text is longer than the English baseline.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a main today view that summarizes the user's current-day medications and reminder items without requiring navigation to multiple screens.
- **FR-001a**: System MUST make the today view the main landing view after setup is complete, while keeping medication management reachable from the today view.
- **FR-002**: System MUST include active medications that have reminders scheduled for the current calendar day.
- **FR-003**: System MUST display reminder items in a clear order that prioritizes due-now items, then upcoming items, then missed items, then handled items, while preserving understandable time order within each status.
- **FR-004**: System MUST clearly label each reminder item's medication name, reminder time, and current status.
- **FR-005**: System MUST distinguish at least these current-day statuses: due now, upcoming, missed, and handled.
- **FR-006**: System MUST keep status understandable without relying on color alone by using visible text and/or icons in addition to any color styling.
- **FR-007**: System MUST provide an empty state for users with no saved medications that explains the situation and offers a clear add-medication action.
- **FR-008**: System MUST provide an empty state for users with medications but no scheduled reminders that explains the situation and offers a clear schedule-reminder action.
- **FR-009**: System MUST provide a clear state when today's reminders are all handled or no more reminders remain today.
- **FR-010**: System MUST allow users to reach add-medication and schedule-reminder flows from the today view when those actions are relevant.
- **FR-011**: Users MUST be able to mark due or upcoming reminder items as handled directly from the today view.
- **FR-012**: System MUST immediately reflect a dashboard-handled reminder as handled for the current day.
- **FR-013**: System MUST reflect locally saved medication and reminder data after app restart.
- **FR-014**: System MUST remain useful when the device is offline and MUST NOT require an account or internet connection to show the dashboard.
- **FR-015**: System MUST avoid account, backup, sync, donation, sharing, analytics, or remote-service prompts in the today view unless a separate approved feature introduces them.
- **FR-016**: System MUST provide user-visible copy, dates, times, statuses, and empty-state text in a localization-ready form for English and Latin American Spanish.
- **FR-017**: System MUST support large text, screen readers, high contrast, large touch targets, logical reading order, and visible focus for all dashboard content and actions.
- **FR-018**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline for calm tone, readable spacing, large touch targets, pressure-free choices, and privacy-preserving language.
- **FR-019**: System MUST handle notification-permission-denied states without blocking the dashboard or hiding locally saved reminder schedules.
- **FR-020**: System MUST update or refresh the today grouping when the current day changes while the app is open or after the app restarts.
- **FR-021**: System MUST treat an unhandled reminder as due now from its scheduled time until 60 minutes after that scheduled time.
- **FR-022**: System MUST suppress today's alert for a reminder when the user marks that reminder handled before its scheduled time.
- **FR-023**: System MUST show an unhandled reminder as missed when it is more than 60 minutes past its scheduled time, and MUST keep it missed until the user marks it handled or the current day ends.

### Key Entities

- **Today Reminder Item**: A current-day reminder instance derived from a medication and a reminder schedule; includes medication name, reminder time, status, and whether it has been handled for the day.
- **Dashboard Section**: A visible grouping of today reminder items, such as due now, upcoming, missed, handled, or an empty/clear-day state.
- **Medication Summary**: The medication information needed on the dashboard, including name, active/inactive state, and whether it has reminders relevant to today.
- **Daily Handling State**: The user's local record that a reminder for the current day has already been handled, including reminders marked handled directly from the today view.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 90% of first-time users can identify the next medication reminder for today within 5 seconds when a reminder exists.
- **SC-002**: Users can reach the add-medication or schedule-reminder action from relevant empty states in no more than one tap from the today view.
- **SC-003**: 100% of due-now, upcoming, missed, and handled reminder items include non-color status text or icon labels.
- **SC-004**: The today view remains readable with large text enabled, with no clipped primary content or blocked actions in accessibility verification.
- **SC-005**: Screen reader verification announces medication name, reminder time, and status for every reminder item in a logical order.
- **SC-006**: The today view loads locally saved dashboard content after app restart and while offline in manual verification.
- **SC-007**: English and Latin American Spanish dashboard states use localized, user-facing copy for headings, statuses, dates, times, empty states, and actions.

## Assumptions

- The dashboard uses medications and reminder schedules already saved locally by earlier features.
- "Due now" means a reminder whose scheduled time is currently actionable from its scheduled time until 60 minutes after that scheduled time.
- "Handled" means the user has locally recorded that today's reminder item no longer needs attention.
- Inactive medications are not shown as due reminders, but may influence empty-state wording when all saved medications are inactive.
- The first version focuses on the current calendar day only and does not provide a multi-day calendar or history view.
- The today view is local-first and privacy-preserving; it does not introduce account, sync, cloud backup, sharing, donation, analytics, or remote-service behavior.
