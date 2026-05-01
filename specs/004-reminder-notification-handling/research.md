# Research: Reminder Notification Handling

## Decision: Extend the existing Flutter medications feature

**Rationale**: The app already stores medications, reminder schedules, local
notification delivery state, and localized user-visible strings in the Flutter
codebase. Due reminder handling needs medication names, dosage labels, and saved
schedule data, so keeping the feature inside the medication module preserves the
current domain boundaries.

**Alternatives considered**: A separate reminder module was rejected for v1
because it would duplicate medication and schedule loading. Native-only
platform screens were rejected because they split accessibility and localization
behavior across platforms.

## Decision: Persist due reminder state locally behind a repository

**Rationale**: The spec requires no duplicate or missed reminder states when the
device is offline, restarted, or notification permission changes. A local
repository gives each due reminder a stable identity and lets notification
actions, app startup reconciliation, and in-app views read and update the same
state.

**Alternatives considered**: Treating notifications as the source of truth was
rejected because notifications can be disabled, dismissed, delayed, or unavailable.
Keeping due reminder state only in memory was rejected because restarts would lose
unresolved and completed outcomes.

## Decision: Identify due reminders by medication and scheduled occurrence time

**Rationale**: Idempotency depends on a deterministic key. Medication id plus the
scheduled local occurrence time distinguishes nearby reminders, lets repeated
callbacks update the same due reminder, and prevents contradictory final states.

**Alternatives considered**: A generated id per callback was rejected because
retries could create duplicates. Medication id alone was rejected because a
medication can have more than one daily scheduled time.

## Decision: Use one app-wide configurable remind-again-later interval

**Rationale**: The clarified spec requires configurability with a 10-minute
default. One app-wide setting keeps the experience simple for older adults while
still allowing the user to change the interval once for all medications.

**Alternatives considered**: Per-medication intervals were rejected because they
increase setup and test complexity. Choosing an interval every time was rejected
because it adds a decision at a time-sensitive moment.

## Decision: Route notification actions and in-app actions through one action handler

**Rationale**: Taken, skipped, and remind-again-later actions must be
idempotent, local, and consistent regardless of where the user acts. A shared
handler can reject contradictory final states, preserve action timestamps, and
cancel or reschedule notification work consistently.

**Alternatives considered**: Updating state directly from widgets and
notification callbacks was rejected because it risks divergent behavior.

## Decision: Add due-reminder reconciliation at app startup and permission changes

**Rationale**: A reminder can become due while notifications are disabled, the
device is offline, or the app/device restarts. Reconciliation compares active
local schedules with existing due reminder states and creates missing unresolved
states without duplicating completed or pending remind-again-later records.

**Alternatives considered**: Scheduling all recovery through background work was
rejected because it can increase battery cost and platform complexity. Manual
user recovery was rejected because users should not need to recreate reminders
after permission or restart edge cases.

## Decision: Keep notification copy privacy-preserving but useful

**Rationale**: The user explicitly wants medication name, dosage label if
available, and scheduled time in the local notification. The app remains
private by keeping this data on device and avoiding remote delivery. In-app views
can provide fuller status without adding cloud services or analytics.

**Alternatives considered**: Hiding all medication details in notifications was
rejected because it conflicts with the requested clear reminder. Sending remote
push notifications was rejected because it would expose medication-adjacent data
to external services and break the local-first v1 model.

## Decision: Verify platform notification behavior manually, cover state rules with automated tests

**Rationale**: Unit and widget tests can prove due state transitions,
idempotency, repository persistence, localization readiness, and accessibility
expectations. Real notification delivery and notification action behavior vary by
iOS/Android device state and must also be verified manually.

**Alternatives considered**: Relying only on manual testing was rejected because
state transitions and regressions need repeatable checks. Relying only on
automated tests was rejected because platform notification behavior cannot be
fully proven in the Flutter test environment.
