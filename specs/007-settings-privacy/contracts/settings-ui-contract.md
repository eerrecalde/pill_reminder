# Settings UI Contract

This contract defines the user-visible settings behavior for implementation and tests. It is a UI/application contract, not a network API.

## Entry Point

- The main app exposes a settings action from the app bar or equivalent primary navigation.
- Opening settings does not require an account, internet connection, ad consent, tracking consent, or remote service.
- Settings opens to a single scrollable surface with clear sections for language, accessibility support, notifications, privacy, and local data control.

## Language Section

- Shows two supported choices: `English` and `Español (Latinoamérica)`.
- Communicates the selected language with text and selection state.
- Changing language updates settings copy, navigation labels, confirmation messages, and error states without restarting the app.
- Closing and reopening the app preserves the selected language.

## Accessibility Section

- Explains in plain language that the app follows device settings for text size, screen reader, focus, and contrast.
- Does not expose separate in-app text size or contrast toggles.
- Remains readable and reachable with large text; content scrolls or reflows without clipping.
- Provides useful semantics labels and a logical reading order.

## Notification Section

- On entry or refresh, checks notification status through `NotificationPermissionService.checkStatus()`.
- Allowed state says reminder alerts are on and does not show corrective warning language.
- Denied/not allowed state explains that reminders may not alert and offers a respectful path to adjust access.
- Blocked/restricted state explains that access can be adjusted in device settings if the user chooses.
- Unavailable state explains that the app cannot confirm notification status right now and can try again later.
- Status is expressed in text and accessible labels, not color alone.

## Privacy Section

- Explains that medication and reminder data is saved only on this device.
- Explains that the app does not require accounts, ads, tracking, backup, sync, sharing, analytics, donation prompts, or remote services for this feature.
- Uses localization-ready plain language in English and Latin American Spanish.

## Local Data Control Section

- If there is no medication or reminder data, shows a plain-language empty state and does not make deletion the primary action.
- If local reminder data exists, shows an available delete action with non-alarmist copy.
- Starting deletion opens a confirmation before any data is removed.
- Confirmation states that medication records, reminder schedules, due reminder state, reminder handling state, and medication history will be removed from this device.
- Confirmation includes a clearly visible cancel action that leaves data unchanged.
- Confirming deletion deletes local reminder data and cancels related scheduled local notifications.
- On success, settings shows a completion message and an undo/recovery action for 30 seconds.
- Selecting undo/recovery within 30 seconds restores deleted local reminder data.
- After 30 seconds, settings communicates that the recovery window ended and the data can no longer be restored through settings.
- If deletion or restore fails, settings explains the outcome calmly and preserves existing data whenever deletion did not complete.

## Accessibility And Localization Acceptance

- Minimum touch target is 48px; primary and destructive actions prefer 56px height.
- Screen reader order follows the visual order: page title, sections, controls, explanatory text, actions.
- Dynamic text size does not clip labels, confirmation copy, destructive actions, or recovery messages.
- Focus states are visible for keyboard/switch navigation.
- Every visible string and semantics label is present in English and Latin American Spanish localization files.
