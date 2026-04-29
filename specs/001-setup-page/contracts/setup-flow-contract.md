# Contract: Setup Flow

This contract defines user-visible states and app behavior for the first-run setup flow. It is a UI/state contract for the Flutter app, not a network API.

## Entry Conditions

- If local setup preferences are missing or `isComplete` is false, the app shows the setup flow before medication entry.
- If `isComplete` is true, the app opens the main app.
- If notifications are skipped, denied, blocked, or unavailable after setup, the main app shows a non-blocking reminder status until reminders can be delivered.

## Screen 1: Language Selection

**Content**

- Title: "Choose your language"
- Actions: "English", "Español (Latinoamérica)"

**Behavior**

- Selecting a language stores the preference and advances to privacy explanation.
- Remaining setup copy switches immediately to the selected language.
- The user can return or recover from a mistaken language choice before completing setup.

**Accessibility**

- Each language action has a meaningful screen-reader label.
- Selected state is communicated by text/semantics and check icon, not color alone.
- Touch target height is at least 56px.

## Screen 2: Privacy Explanation

**Content**

- Title: "Your information stays with you"
- Body: "Your medication reminders are saved only on this device." and "No account. No sharing."
- Action: "Continue"

**Behavior**

- Continuing stores privacy acknowledgement and advances to notification permission.
- The screen does not request medication details or account information.

**Accessibility**

- Illustration is decorative or has a concise semantic label if meaningful.
- Text remains readable with large text settings and does not clip.
- Primary action remains reachable with screen readers and keyboard/focus navigation.

## Screen 3: Notification Permission

**Content**

- Title: "Get reminder alerts"
- Body: "We can remind you when it's time to take your medication."
- Primary action: "Turn on reminders"
- Secondary action: "Not now"

**Behavior**

- "Turn on reminders" requests notification permission through the app notification permission service.
- Granted permission stores `granted`, completes setup, and opens the main app.
- Denied, blocked, or unavailable permission stores the matching status, completes setup, and opens the main app with reminder status visible.
- "Not now" stores `skipped`, completes setup, and opens the main app with reminder status visible.
- No path blocks the user from entering the app because notifications are unavailable.

**Accessibility**

- Both actions are full width with at least 56px height.
- The secondary action is visually distinct without being alarming.
- Denied or skipped feedback avoids red warning styling during onboarding.

## Main-App Reminder Status

**Visible When**

- Notification permission status is `skipped`, `denied`, `blocked`, or `unavailable`.

**Behavior**

- Status is non-blocking and does not cover primary app actions.
- Status clearly says reminders cannot be delivered until notifications are enabled.
- Status includes a recovery action or guidance path.
- Status disappears when permission status becomes `granted`.

**Accessibility**

- Status is announced as important but not as a blocking alert.
- Meaning is communicated with text and icon/structure, not color alone.
- Recovery action has a clear accessible name.

## Tablet Layout

- Content width is constrained for readability on wide screens.
- Primary actions remain full width within the content column.
- The flow keeps one decision per screen; tablet layout must not combine screens into a dense wizard.

## Localization Contract

- All setup and reminder-status strings have English and Latin American Spanish entries.
- Locale values are `en` and `es_419`.
- Business logic does not contain user-visible strings.
