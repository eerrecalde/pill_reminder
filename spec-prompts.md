# Pill Reminder Spec Kit Feature Prompts

This document breaks the Pill Reminder app into Spec Kit-sized features and
provides `/speckit.specify` prompts for each one.

Spec Kit guidance: each `/speckit.specify` prompt should describe what to build
and why it matters, not the implementation stack. Each prompt should cover one
feature.

Project context:

- Flutter pill reminder app for older adults
- Offline-first and account-free for core reminder use
- Reliable local notifications
- Private medication data with no ads or mandatory tracking
- English and Latin American Spanish as first-class locales
- Accessibility for older adults as a release requirement
- Minimal complexity and justified dependencies

## Recommended Feature Breakdown

1. Setup and first-run experience
2. Add medication
3. Create reminder schedule
4. Today reminders dashboard
5. Reminder notification handling
6. Edit, pause, and resume reminders
7. Medication history
8. Settings, language, accessibility, and privacy controls
9. Optional donation flow, later
10. Optional caregiver/export support, later

Recommended MVP order:

1. Setup and first-run experience
2. Add medication
3. Create reminder schedule
4. Today reminders dashboard
5. Reminder notification handling

## Prompt 1: Setup Page

```text
/speckit.specify Setup Page - Create the first-run setup experience for an offline, account-free pill reminder app for older adults. The setup should help a new user choose their preferred language between English and Latin American Spanish, understand that medication data stays private on their device, and enable reminder notifications. The flow must be short, calm, and easy to complete without technical terms. Users must be able to continue using the app even if they deny notification permission, but the app should clearly explain that reminders cannot be delivered until permission is enabled. The experience must support large text, screen readers, high contrast, large touch targets, and clear recovery from permission-denied states making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 2: Add Medication

```text
/speckit.specify Add Medication - Create the medication entry flow for older adults and caregivers to add a medication that will later receive reminders. Users should be able to enter a medication name, optional dosage label, optional notes, and an active/inactive status. The flow should avoid medical assumptions, avoid requiring internet access or an account, and make it clear that the information is stored privately on the device. The medication entry experience must be accessible with large text, screen readers, large touch targets, and validation messages that do not rely on color alone. User-facing copy must be ready for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 3: Reminder Schedule

```text
/speckit.specify Reminder Schedule - Create the reminder schedule flow for a medication. Users should be able to choose simple reminder times for a medication, including one or more times per day, and save the schedule without needing an account or internet connection. The flow should prioritize common daily medication routines and avoid complex recurrence rules in the first version. Users must be able to review the selected schedule before saving, understand when reminders will happen, and recover from invalid or incomplete choices. The schedule must be reliable after app restart, support notification-permission edge cases, and remain usable with large text, screen readers, large touch targets, and localization-ready date and time formatting for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 4: Today Dashboard

```text
/speckit.specify Today Dashboard - Create the main today view for the pill reminder app. The view should show the user's medications and reminders for the current day in a clear, readable order, emphasizing what is due now, what is upcoming, and what has already been handled. Users should be able to quickly understand their day without opening multiple screens. Empty states should help new users add their first medication or reminder. Status must not rely on color alone, and the screen must support large text, screen readers, high contrast, large touch targets, and localization-ready copy for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 5: Reminder Notification Handling

```text
/speckit.specify Reminder Notification Handling - Create the reminder handling experience for when a medication reminder becomes due. The user should receive a clear local reminder notification with medication name, dosage label if available, and the scheduled time. From the reminder or app, the user should be able to mark the medication as taken, skip it, or be reminded again later. The app must avoid duplicate or missed reminder states when the device is offline, restarted, or notification permission changes. The experience must be understandable for older adults, accessible with screen readers and large text, and must keep medication data private on the device making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 6: Edit, Pause, Resume

```text
/speckit.specify Edit, Pause, Resume - Create editing controls for medications and reminder schedules. Users should be able to change medication details, change reminder times, pause reminders temporarily, resume reminders, and delete a medication or schedule with clear confirmation. Changes must be reflected in future reminders reliably and must not create duplicate notifications. The flow should be simple enough for older adults, provide clear recovery from mistakes, work offline without an account, and include accessible, localization-ready confirmation and error states making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 7: Medication History

```text
/speckit.specify Medication History - Create a simple medication history view that helps users review whether scheduled medications were marked taken, skipped, missed, or snoozed. The history should be easy to scan by day and medication, avoid judgmental language, and remain private on the device. Users should be able to understand recent reminder activity without needing an account or internet connection. The history must support large text, screen readers, non-color-only status indicators, and localization-ready dates, times, and labels for English and Latin American Spanish making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```

## Prompt 8: Settings and Privacy

```text
/speckit.specify Settings and Privacy - Create the settings area for language, accessibility, notification status, privacy, and local data control. Users should be able to change language between English and Latin American Spanish, review notification permission status, see a plain-language explanation of local private storage, and delete local medication/reminder data with confirmation. The settings area must not include ads, tracking, or required accounts. It should be accessible for older adults, use clear non-technical language, and provide safe recovery from destructive actions making sure to always use the UX Design guidelines in [this doc](./docs/ux-design.md).
```
