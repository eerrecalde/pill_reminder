# Feature Specification: Setup Page

**Feature Branch**: `001-setup-page`  
**Created**: 2026-04-29  
**Status**: Draft  
**Input**: User description: "Setup Page - Create the first-run setup experience for an offline, account-free pill reminder app for older adults. The setup should help a new user choose their preferred language between English and Latin American Spanish, understand that medication data stays private on their device, and enable reminder notifications. The flow must be short, calm, and easy to complete without technical terms. Users must be able to continue using the app even if they deny notification permission, but the app should clearly explain that reminders cannot be delivered until permission is enabled. The experience must support large text, screen readers, high contrast, large touch targets, and clear recovery from permission-denied states."

## Clarifications

### Session 2026-04-29

- Q: How visible should notification-denied recovery remain after setup? → A: Show a non-blocking reminder status on the main app after setup until notifications are enabled.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Complete First-Run Setup (Priority: P1)

As an older adult opening the pill reminder app for the first time, I want a short and calm setup flow so I can choose my language, understand my privacy, and reach the app without confusion.

**Why this priority**: The setup page is the first experience and must build confidence before the user enters medication information.

**Independent Test**: Can be fully tested by launching the app with no prior setup, completing each setup step, and confirming the user reaches the main app with their selected language and setup completion saved.

**Acceptance Scenarios**:

1. **Given** a new user opens the app for the first time, **When** the setup flow begins, **Then** the user sees a simple language choice between English and Latin American Spanish before any medication details are requested.
2. **Given** the user selects a language, **When** they continue, **Then** all remaining setup text appears in the selected language.
3. **Given** the user completes the setup flow, **When** they next open the app, **Then** the setup flow does not repeat unless the user chooses to revisit setup-related preferences.

---

### User Story 2 - Understand Device Privacy (Priority: P2)

As a new user, I want plain reassurance that my medication information stays on my device so I can feel safe using the app without creating an account.

**Why this priority**: Privacy understanding is central to an offline, account-free medication app and supports user trust before medication entry.

**Independent Test**: Can be tested by completing the privacy step and confirming the user receives a clear explanation that no account is required and medication data stays private on the device.

**Acceptance Scenarios**:

1. **Given** the user has chosen a language, **When** the privacy step appears, **Then** it explains in plain language that medication information stays on the user's device and no account is needed.
2. **Given** the privacy explanation is visible, **When** the user uses large text or a screen reader, **Then** the explanation remains readable, correctly ordered, and understandable without technical terms.

---

### User Story 3 - Enable or Decline Notifications (Priority: P3)

As a new user, I want to enable reminder notifications if I choose, or continue without them, so I stay in control and understand what happens either way.

**Why this priority**: Reminder delivery is core to the app's value, but permission denial must not block use.

**Independent Test**: Can be tested by granting notifications, denying notifications, and returning from a denied state to confirm both paths are clear and recoverable.

**Acceptance Scenarios**:

1. **Given** the user reaches the notification step, **When** they choose to enable notifications and permission is granted, **Then** setup confirms reminders can be delivered.
2. **Given** the user denies notification permission, **When** the app returns to setup, **Then** the user can continue into the app and sees a clear explanation that reminders cannot be delivered until permission is enabled.
3. **Given** notifications are denied and setup is complete, **When** the user reaches the main app, **Then** the app shows a non-blocking reminder status until notifications are enabled.
4. **Given** notifications are denied, **When** the user revisits the notification recovery path, **Then** the app clearly explains how to enable reminders again without blaming or alarming the user.

### Edge Cases

- The device is offline throughout setup; the flow still completes because no account or remote connection is required.
- The user starts setup, closes the app, and returns later; completed setup choices are preserved and the user resumes from a sensible point or can restart setup without losing entered medication data.
- Notification permission is denied, unavailable, or previously blocked; the app allows continuation and presents the reminder limitation plus a non-blocking main-app recovery path.
- The user changes text size to a very large setting; all setup text and actions remain readable, visible, and usable without horizontal scrolling or clipped controls.
- The user relies on a screen reader; language choices, privacy explanation, permission status, and actions are announced in a logical order with meaningful labels.
- The user uses high contrast or cannot rely on color; status and choices are communicated with text and structure, not color alone.
- The user accidentally selects the wrong language; the flow provides a clear way to go back or change language before completion.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST show the setup experience automatically for users who have not completed first-run setup.
- **FR-002**: Users MUST be able to choose either English or Latin American Spanish as their preferred app language during setup.
- **FR-003**: System MUST apply the selected language to all setup content immediately after language selection.
- **FR-004**: System MUST explain, in plain non-technical language, that medication data stays private on the user's device and that no account is required.
- **FR-005**: System MUST avoid requesting medication details before the user has chosen a language and seen the privacy explanation.
- **FR-006**: System MUST offer a clear notification enablement step that explains reminders need notification permission to be delivered.
- **FR-007**: Users MUST be able to continue using the app if they skip or deny notification permission.
- **FR-008**: System MUST clearly explain after skipped or denied notification permission that reminders cannot be delivered until permission is enabled.
- **FR-009**: System MUST provide a clear recovery path from skipped, denied, unavailable, or blocked notification states so users can understand how to enable reminders later.
- **FR-009a**: System MUST show a non-blocking reminder status in the main app after setup whenever notification permission is skipped, denied, blocked, or unavailable, and continue showing it until reminders can be delivered.
- **FR-010**: System MUST save setup completion, selected language, privacy acknowledgement, and notification permission status as local preferences.
- **FR-011**: System MUST allow users to revisit setup-related preferences after setup, including language and notification guidance.
- **FR-012**: System MUST preserve local-first, account-free core reminder use.
- **FR-013**: System MUST keep medication data private by default and introduce no medication data sharing, remote account requirement, analytics dependency, donation flow, backup requirement, or remote-service requirement as part of this setup feature.
- **FR-014**: System MUST provide setup copy, notification guidance, permission-denied guidance, dates, times, and error states in a localization-ready form for English and Latin American Spanish.
- **FR-015**: System MUST support older-adult accessibility needs throughout setup, including large text, screen readers, high contrast, large touch targets, visible focus, clear navigation, and non-color-only status communication.
- **FR-016**: System MUST keep the setup flow short enough that the primary happy path contains no more than three decision points: language, privacy acknowledgement, and notification choice.
- **FR-017**: System MUST use calm, direct wording and avoid technical terms such as storage architecture, synchronization, tokens, operating-system APIs, or backend services in user-facing setup copy.
- **FR-018**: System MUST provide clear back or change options for recoverable setup choices, including mistaken language selection before setup completion.

### Key Entities

- **Setup Preference**: Represents the user's first-run setup state, including whether setup is complete and where the user should resume if interrupted.
- **Language Preference**: Represents the user's chosen setup and app language, limited to English and Latin American Spanish for this feature.
- **Privacy Acknowledgement**: Represents that the user has seen and continued past the device-privacy explanation.
- **Notification Permission Status**: Represents whether reminders can currently be delivered, including granted, skipped, denied, blocked, or unavailable states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 90% of first-time users can complete the setup happy path in under 2 minutes during usability testing.
- **SC-002**: At least 95% of first-time users can identify, before entering medication details, that no account is required and medication data stays on their device.
- **SC-003**: 100% of setup paths allow the user to reach the main app, including paths where notification permission is skipped or denied.
- **SC-004**: At least 90% of users who deny notifications understand that reminders cannot be delivered until permission is enabled, as measured by a comprehension check or moderated usability test.
- **SC-005**: The complete setup flow can be completed with screen reader navigation and large text enabled without clipped text, blocked actions, or loss of meaning.
- **SC-006**: All primary setup actions meet large touch target expectations and remain distinguishable in high contrast mode without relying on color alone.
- **SC-007**: Users can recover from a denied notification state and find guidance for enabling reminders later in under 30 seconds during usability testing.

## Assumptions

- The initial setup is intended for a single local user of the app on their own device.
- English is the default language shown before the user makes a language choice.
- Latin American Spanish means neutral, clear Spanish appropriate for a broad Latin American audience rather than country-specific wording.
- Notification permission is requested only after the user has seen why reminders need it.
- Denied or blocked notification recovery may require the user to change device settings, but the setup experience only needs to guide the user clearly and let them continue.
- This feature covers first-run setup and recovery messaging only; creating medication schedules and delivering reminders are handled by other app flows.
