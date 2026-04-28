<!--
Sync Impact Report
Version change: template or none -> 1.0.0
Modified principles:
- Template placeholders -> I. Accessibility for Older Adults
- Template placeholders -> II. Simple Reminder Setup
- Template placeholders -> III. Reliable Local Notifications
- Template placeholders -> IV. English and Latin American Spanish Localization
- Template placeholders -> V. Privacy, No Ads, Respectful Donations
- Template placeholders -> VI. Low Complexity
Added sections:
- Product Constraints
- Delivery Workflow and Quality Gates
Removed sections:
- None
Templates requiring updates:
- updated: .specify/templates/plan-template.md
- updated: .specify/templates/spec-template.md
- updated: .specify/templates/tasks-template.md
- not present: .specify/templates/commands/*.md
Runtime guidance requiring updates:
- updated: README.md
Follow-up TODOs:
- None
-->
# Pill Reminder Constitution

## Core Principles

### I. Accessibility for Older Adults
The app MUST be usable by older adults with low vision, reduced dexterity,
hearing differences, medication stress, or limited technology confidence.
Every user-facing feature MUST support readable text scaling, sufficient
contrast, clear touch targets, plain language, assistive technology semantics,
and forgiving interaction flows. Critical actions MUST avoid hidden gestures,
small tap areas, time pressure, and ambiguous icons without labels.

Rationale: A pill reminder that is difficult to perceive, understand, or operate
can directly undermine medication adherence.

### II. Simple Reminder Setup
The primary reminder setup path MUST let a user create a medication reminder
with the fewest reasonable steps and without requiring account creation,
internet access, or advanced scheduling knowledge. Defaults MUST favor common
daily medication routines while still allowing dosage notes, multiple times,
start and end dates, and confirmation before saving. Each setup flow MUST be
independently testable with an older-adult usability scenario.

Rationale: Reminder creation is the core value of the product; complexity here
prevents the app from helping the people it is built for.

### III. Reliable Local Notifications
Medication reminders MUST use local device notifications as the default delivery
mechanism. Features that affect reminders MUST specify how notifications behave
when the app is closed, the device restarts, permissions change, time zones
change, daylight saving time changes, or the device is offline. Notification
scheduling, cancellation, rescheduling, and permission recovery MUST be covered
by automated tests where the platform allows, plus manual verification steps for
iOS and Android.

Rationale: The app cannot depend on a server, advertising network, or constant
connectivity to deliver medication reminders.

### IV. English and Latin American Spanish Localization
All user-facing text MUST be localizable in English and Latin American Spanish.
New copy MUST be written in plain language, avoid idioms that translate poorly,
and support longer Spanish strings without truncation or layout overlap.
Medication, reminder, permission, privacy, and donation language MUST be
reviewed in both locales before release.

Rationale: Language access is part of accessibility, and Latin American Spanish
must be treated as a first-class product experience rather than a later add-on.

### V. Privacy, No Ads, Respectful Donations
Medication data MUST stay on the user's device unless a future feature is
explicitly specified, consented to, and reviewed under this constitution. The app
MUST NOT include ads, tracking for advertising, data brokerage, dark patterns, or
paywalls around reminder functionality. Donations MAY be offered only as an
optional, non-intrusive path that does not interrupt medication workflows,
punish non-donors, or imply health outcomes depend on payment.

Rationale: Medication information is sensitive. Trust is a product requirement,
not a monetization tradeoff.

### VI. Low Complexity
The app MUST stay small, understandable, and locally maintainable. Each feature
MUST justify new dependencies, background services, abstractions, platform
channels, remote services, or state-management layers. Prefer Flutter and Dart
standard patterns, simple local persistence, and direct domain models until a
clear user need proves otherwise. Any complexity accepted for reliability,
accessibility, localization, or privacy MUST be documented in the plan.

Rationale: Lower complexity improves reliability, auditability, accessibility
reviews, and long-term maintenance.

## Product Constraints

- Target platforms are iOS and Android unless a feature explicitly broadens the
  scope.
- Core reminder creation, editing, notification delivery, and medication list
  viewing MUST work offline after installation.
- The app MUST avoid account requirements for core reminder use.
- User-facing medication data MUST be minimized to what reminder behavior needs.
- Accessibility, localization, privacy, and notification reliability are release
  blockers for user-facing medication workflows.
- Donation features MUST be outside reminder setup, reminder delivery, and
  urgent acknowledgement flows.

## Delivery Workflow and Quality Gates

- Specifications MUST include older-adult accessibility scenarios, English and
  Latin American Spanish acceptance criteria, local notification edge cases, and
  privacy expectations for any feature that touches medication data.
- Plans MUST pass a Constitution Check before design work and again after design.
  Any violation MUST document the user need, rejected simpler alternative, and
  mitigation.
- Tasks MUST include concrete accessibility, localization, notification,
  privacy, and low-complexity verification work when the feature surface touches
  those areas.
- Reviews MUST reject user-facing work that ships untranslated text, inaccessible
  controls, intrusive donation prompts, ads, unnecessary account requirements, or
  notification behavior that has not been tested.
- Releases MUST include manual smoke checks on iOS and Android for reminder
  scheduling, delivery, cancellation, permission recovery, text scaling, and both
  supported locales.

## Governance

This constitution supersedes conflicting project guidance. Amendments MUST be
made through a documented change to this file, include a Sync Impact Report, and
update affected Spec Kit templates or runtime guidance in the same change.

Versioning follows semantic versioning:

- MAJOR: Remove or redefine a core principle, weaken privacy/no-ads guarantees,
  or change the target user commitment.
- MINOR: Add a principle, add a governance section, or materially expand product
  constraints or quality gates.
- PATCH: Clarify wording, correct errors, or refine examples without changing
  obligations.

Compliance review is required during specification, planning, task generation,
code review, and release readiness. When a feature cannot satisfy a principle,
the plan MUST record the violation and receive explicit maintainer approval
before implementation begins.

**Version**: 1.0.0 | **Ratified**: 2026-04-28 | **Last Amended**: 2026-04-28
