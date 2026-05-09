# Feature Specification: Settings and Privacy

**Feature Branch**: `008-settings-privacy`  
**Created**: 2026-05-09  
**Status**: Draft  
**Input**: User description: "Settings and Privacy - Create the settings area for language, accessibility, notification status, privacy, and local data control. Users should be able to change language between English and Latin American Spanish, review notification permission status, see a plain-language explanation of local private storage, and delete local medication/reminder data with confirmation. The settings area must not include ads, tracking, or required accounts. It should be accessible for older adults, use clear non-technical language, and provide safe recovery from destructive actions making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md)."

## Clarifications

### Session 2026-05-09

- Q: How long should the recovery option remain available after confirmed deletion? → A: 30-second undo window after deletion.
- Q: What should the accessibility settings section control? → A: Accessibility section explains support and uses device settings.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review Settings and Privacy Clearly (Priority: P1)

As an older adult using the reminder app, I want one calm settings area where I can understand my language, device-based accessibility support, notification, privacy, and data choices without technical language or account prompts.

**Why this priority**: The settings area is the user's main place to confirm the app is private, understandable, and under their control.

**Independent Test**: Can be fully tested by opening settings and confirming that each required topic is visible, written in plain language, accessible with large text and screen readers, and free of ads, tracking, sign-in, or account prompts.

**Acceptance Scenarios**:

1. **Given** the user opens the app, **When** they enter settings, **Then** they see clearly labeled sections for language, device-based accessibility support, notifications, privacy, and local data control.
2. **Given** the user uses large text or a screen reader, **When** they review settings, **Then** all controls and explanations remain readable, reachable, and announced in a useful order.
3. **Given** the user is reviewing settings, **When** they look for account, advertising, or tracking controls, **Then** the settings area does not require or promote any account, ad, or tracking setup.

---

### User Story 2 - Change Preferred Language (Priority: P1)

As a user, I want to change the app language between English and Latin American Spanish so the reminder experience stays understandable for me or someone helping me.

**Why this priority**: Language is foundational to every other privacy, safety, and reminder decision in the app.

**Independent Test**: Can be fully tested by changing the language in settings and confirming that user-facing settings copy, navigation labels, and confirmation messages appear in the selected language.

**Acceptance Scenarios**:

1. **Given** the app is using English, **When** the user selects "Español (Latinoamérica)" in settings, **Then** the app confirms the choice and displays supported user-facing settings text in Latin American Spanish.
2. **Given** the app is using Latin American Spanish, **When** the user selects "English" in settings, **Then** the app confirms the choice and displays supported user-facing settings text in English.
3. **Given** the user changes language, **When** they close and reopen the app, **Then** the selected language remains active.

---

### User Story 3 - Check Notification Status (Priority: P2)

As a user, I want to see whether reminder notifications are currently allowed so I know if medication reminders can alert me.

**Why this priority**: Notification permission affects reminder reliability, but it should be presented without pressure or blame.

**Independent Test**: Can be fully tested by viewing settings with notifications allowed and denied, confirming that the status is accurate and the next step is explained calmly.

**Acceptance Scenarios**:

1. **Given** notifications are allowed, **When** the user opens notification settings, **Then** they see that reminder alerts are on and no corrective warning is shown.
2. **Given** notifications are denied or not yet allowed, **When** the user opens notification settings, **Then** they see a plain-language status and a respectful path to adjust notification access.
3. **Given** notification status cannot be checked at that moment, **When** the user opens notification settings, **Then** they see a calm message that the app cannot confirm the status right now and can try again later.

---

### User Story 4 - Understand and Control Local Data (Priority: P2)

As a privacy-conscious user, I want to understand what medication and reminder information is stored on my device and delete it only after a careful confirmation.

**Why this priority**: Local data control is central to trust and privacy, and deletion can cause real loss if it is too easy to trigger accidentally.

**Independent Test**: Can be fully tested by reviewing the privacy explanation, starting deletion, canceling deletion, confirming deletion, and using the recovery option within the allowed recovery window.

**Acceptance Scenarios**:

1. **Given** the user opens privacy settings, **When** they read the local storage explanation, **Then** they understand that medication and reminder data stays on this device and is not shared through accounts, ads, or tracking.
2. **Given** the user starts deleting local medication and reminder data, **When** the confirmation appears, **Then** it clearly explains what will be removed and offers an obvious way to cancel.
3. **Given** the user cancels deletion, **When** they return to settings, **Then** no medication or reminder data has been removed.
4. **Given** the user confirms deletion, **When** deletion completes, **Then** the app shows a completion message and offers a recovery option for 30 seconds that restores the deleted local medication and reminder data if selected before the recovery window ends.

### Edge Cases

- If the user has no medication or reminder data, the data control area explains that there is nothing to delete and does not show a destructive confirmation as the primary action.
- If notification access is denied outside the app, settings shows the current denied status the next time it can be checked and avoids alarmist language.
- If the device is offline, settings remains usable because language, privacy explanations, notification status review, and local data control do not require an internet connection.
- If the app is restarted after a language change, the selected language is still used.
- If the app is restarted after confirmed deletion and the 30-second recovery window has ended, deleted local medication and reminder data remains deleted.
- If text size is increased, screen content scrolls or reflows without clipping important labels, destructive-action warnings, or confirmation buttons.
- If colors are difficult to distinguish, selected language, notification status, and destructive-action states are also communicated with text and accessible labels.
- If the user looks for accessibility controls, settings explains that the app respects device-level text size, screen reader, focus, and contrast preferences rather than providing separate in-app accessibility toggles.
- If a deletion attempt cannot complete, the app explains that data was not deleted and leaves the existing medication and reminder data available.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a settings area reachable from the app's main experience without requiring an account, sign-in, internet connection, ad consent, or tracking consent.
- **FR-002**: System MUST present settings sections for language, device-based accessibility support, notification status, privacy, and local data control using clear, non-technical language.
- **FR-003**: Users MUST be able to change the app language between English and Latin American Spanish from settings.
- **FR-004**: System MUST preserve the user's selected language after the app is closed and reopened.
- **FR-005**: System MUST show the current reminder notification permission status in plain language, including allowed, denied or not allowed, and temporarily unavailable status.
- **FR-006**: System MUST provide a respectful next step when notifications are not allowed, without blocking use of the app or using fear-based warnings.
- **FR-007**: System MUST explain that medication and reminder information is stored locally on the user's device and is not shared through required accounts, ads, tracking, or remote services.
- **FR-008**: System MUST allow users to delete local medication and reminder data through a deliberate destructive-action flow.
- **FR-009**: System MUST show a confirmation before deleting local medication and reminder data, including what data will be removed and a clearly visible cancel option.
- **FR-010**: System MUST leave all medication and reminder data unchanged when the user cancels the deletion flow or exits before final confirmation.
- **FR-011**: System MUST offer a clearly labeled recovery option for 30 seconds immediately after confirmed deletion so accidental deletion can be reversed before the recovery window ends.
- **FR-012**: System MUST clearly communicate when the 30-second recovery window has ended and data can no longer be restored through settings.
- **FR-013**: System MUST avoid ads, tracking controls, promotional content, required accounts, backup sign-ups, or data-sharing prompts in the settings area.
- **FR-014**: System MUST provide user-visible copy, confirmation text, dates or times if shown, and error states in a localization-ready form for English and Latin American Spanish.
- **FR-015**: System MUST explain that accessibility support follows device-level preferences and MUST define accessible behavior for older adults, including large text support, screen reader labels, minimum comfortable touch targets, readable contrast, visible focus states, and non-color-only status communication.
- **FR-016**: System MUST NOT add separate in-app accessibility toggles for text size or contrast in this feature.
- **FR-017**: System MUST follow `docs/ux-design.md` as the UX and accessibility baseline, including calm tone, large readable text, generous spacing, pressure-free choices, and one primary decision per destructive confirmation step.
- **FR-018**: System MUST keep medication data private by default and document any storage, retention, deletion, sharing, backup, analytics, donation, or remote-service behavior introduced by this feature.
- **FR-019**: System MUST preserve local-first, account-free core reminder use.

### Key Entities *(include if feature involves data)*

- **Settings Preference**: The user's stored app preferences, including selected language; accessibility behavior is explained in settings but follows device-level preferences rather than separate in-app toggles.
- **Notification Status**: The user-facing reminder alert permission state shown in settings, including an explanation and available next step.
- **Privacy Explanation**: Plain-language content that describes local storage, lack of required accounts, and absence of ads or tracking.
- **Local Reminder Data**: Medication names, dosage details, reminder schedules, reminder handling state, and medication history stored on the user's device.
- **Deletion Confirmation**: The safety step that summarizes what will be removed, requires deliberate confirmation, and supports cancellation.
- **Deletion Recovery Window**: The 30-second period after confirmed deletion when the user can restore the removed local medication and reminder data from settings.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 95% of test participants can find the settings area and identify the language, notification, privacy, and data deletion sections within 60 seconds.
- **SC-002**: 90% of test participants can change language between English and Latin American Spanish without assistance.
- **SC-003**: 90% of test participants can correctly state whether reminder notifications are currently allowed after reviewing notification settings.
- **SC-004**: 90% of test participants can explain, in their own words, that medication and reminder data stays on the device and is not used for required accounts, ads, or tracking.
- **SC-005**: 100% of destructive deletion attempts require an explicit confirmation step before local medication or reminder data is removed.
- **SC-006**: 95% of accidental deletion test attempts can be recovered when the user selects the recovery option within 30 seconds after deletion.
- **SC-007**: Primary settings flows complete with screen reader and large text enabled without clipped text, hidden actions, or color-only status communication.
- **SC-008**: Users can review the privacy explanation and reach a safe cancel path from the deletion confirmation in under 2 minutes.

## Assumptions

- The settings area is part of the existing local-first reminder app and applies to the same user who uses medication reminders on the device.
- Accessibility support in this feature focuses on clear explanation and accessible presentation; it does not replace or duplicate device-level accessibility settings.
- The deletion scope includes local medication records, reminder schedules, reminder handling state, and medication history created by the app.
- The recovery option is available for 30 seconds immediately after deletion from within the app; once the recovery window ends, local-only deleted data is no longer recoverable through settings.
- Notification status can be reviewed from settings, but users may still need device-level permission controls to fully change notification access depending on their device.
- The feature does not add cloud backup, sync, export, import, sharing, analytics, donation flows, advertising, or required accounts.
