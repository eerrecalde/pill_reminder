# Research: Reminder Schedule

## Decision: Build the feature as a Flutter Material medication schedule flow

**Rationale**: The repository is a Flutter app with existing Material theme,
localization, setup, medication entry, and widget test patterns. Keeping the
schedule flow in Flutter gives one phone/tablet implementation and lets tests
cover the accessible UI behavior.

**Alternatives considered**: Separate native Android/iOS screens were rejected
because they duplicate accessibility, localization, and state behavior. A
web-first flow was rejected because the target app is mobile.

## Decision: Follow `docs/ux-design.md` as the UX and accessibility baseline

**Rationale**: The constitution requires user-facing setup/onboarding flows to
follow the UX guide, and the user explicitly asked for this feature to use it.
The schedule flow should carry the same calm, simple, older-adult-friendly
experience: one decision per screen where practical, large readable text, 56px
preferred actions, clear focus, descriptive labels, and pressure-free choices.

**Alternatives considered**: A dense single-screen scheduler was rejected because
it increases cognitive load with large text and screen readers. A calendar-style
recurrence builder was rejected because it conflicts with the v1 simple daily
scope.

## Decision: Store reminder schedules locally behind a repository interface

**Rationale**: The feature must work offline, account-free, and after app
restart. Existing medication records already use a repository boundary with
local JSON persistence, so a `ReminderScheduleRepository` keeps schedule storage
consistent while leaving room for later storage changes.

**Alternatives considered**: Storing schedules directly in widgets was rejected
because it couples UI to persistence. Adding Firebase now was rejected because it
would introduce account/remote concepts into a local-first v1 flow.

## Decision: Represent v1 schedules as daily times with an optional end date

**Rationale**: The spec limits v1 to common daily routines, one to four times per
day, indefinite by default, and optional end date. This is understandable for
older adults and avoids complex recurrence rules while still supporting a common
"take until this date" case.

**Alternatives considered**: Weekly/monthly/custom recurrence, start dates,
as-needed schedules, tapering, and required end dates were rejected as v1
complexity. Unlimited daily times were rejected because they make the review and
notification behavior harder to understand.

## Decision: Block scheduling for inactive medications

**Rationale**: Inactive medications are not ready for reminders. Blocking
scheduling and directing the user to make the medication active separately keeps
status changes explicit and avoids creating alerts for a medication the user has
marked inactive.

**Alternatives considered**: Activating inside the schedule flow was rejected
because it adds a second responsibility to scheduling. Saving disabled schedules
for inactive medications was rejected because it creates hidden state that is
harder to explain.

## Decision: Add a notification scheduler service boundary

**Rationale**: Scheduling and canceling platform notifications is a side effect
that depends on permissions and device behavior. A small scheduler boundary lets
the app test schedule validation and repository behavior independently from
platform notification delivery, while manual checks verify iOS/Android behavior.
Use `flutter_local_notifications` behind that boundary because it supports
displaying, scheduling, updating, and canceling local notifications across
Android and iOS, and the current project Flutter SDK satisfies the package's
published minimum SDK requirement.

**Alternatives considered**: Calling platform notification APIs directly from
the schedule screen was rejected because it mixes UI with platform side effects.
Skipping notification scheduling in this feature was rejected because saved
schedules must become deliverable automatically once permission is enabled.
Hand-rolled platform channels were rejected because they add more maintenance
risk than a proven local-notifications plugin for v1.

## Decision: Save schedules even when notifications are unavailable

**Rationale**: Users should not lose their schedule work because permission is
skipped, denied, blocked, or unavailable. The schedule stays local and becomes
deliverable automatically when permission is enabled later, matching the setup
recovery model.

**Alternatives considered**: Blocking save until permission is granted was
rejected because it creates pressure and conflicts with user control. Requiring
users to revisit each schedule after enabling permission was rejected because it
adds avoidable recovery work.
