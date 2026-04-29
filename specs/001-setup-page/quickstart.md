# Quickstart: Setup Page

## Prerequisites

- Flutter SDK compatible with Dart `^3.11.5`
- iOS simulator/device or Android emulator/device for notification permission checks

## Implementation Notes

1. Add local preference persistence with `shared_preferences`.
2. Add notification permission status and settings recovery with `permission_handler`.
3. Add app localization resources for English and Latin American Spanish.
4. Implement setup state under `lib/features/setup/`.
5. Route first app launch through setup when local preferences are incomplete.
6. Keep notification permission behind `NotificationPermissionService` so reminder scheduling and future platform details remain outside setup widgets.
7. Keep setup persistence behind `SetupPreferencesRepository` so a later Firebase implementation can be added without rewriting presentation code.

## Verification

Run automated checks:

```bash
flutter test
```

Manual verification:

1. Fresh install opens language selection.
2. English path completes language, privacy, and notification screens.
3. Latin American Spanish path switches setup copy immediately after language selection.
4. "Not now" completes setup and shows a non-blocking main-app reminder status.
5. Denied notification permission completes setup and shows the same non-blocking status.
6. Granted notification permission completes setup without the main-app reminder status.
7. Setup does not repeat after completion.
8. An interrupted setup resumes at the saved privacy or notification step.
9. A mistaken language selection can be changed before setup completion.
10. Setup-related preferences can be revisited after completion for language and notification guidance.
11. Large text does not clip titles, body copy, or buttons.
12. Screen reader announces language options, privacy explanation, permission choices, and reminder status in a logical order.
13. High contrast mode preserves meaning without relying on color alone.

## Performance Check

- First setup screen appears within 1 second after app start on a typical phone or tablet.
- Setup transitions feel immediate and do not depend on network connectivity.
- No polling, account lookup, analytics call, or remote synchronization runs during setup.
