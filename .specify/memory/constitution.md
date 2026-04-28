<!--
Sync Impact Report
Version change: unratified template -> 1.0.0
Modified principles:
- Template placeholders -> I. Simplicity and Clear Flows
- Template placeholders -> II. Accessibility for Older Adults
- Template placeholders -> III. Reliable Local-First Reminders
- Template placeholders -> IV. Privacy and User Control
- Template placeholders -> V. Maintainable Architecture
- Template placeholders -> VI. Testing as a Release Gate
- Template placeholders -> VII. Consistent, Localizable Experience
- Template placeholders -> VIII. Measured Performance
Added sections:
- Product and Technical Constraints
- Delivery and Review Standards
Removed sections:
- Placeholder Section 2
- Placeholder Section 3
Templates requiring updates:
- ✅ .specify/templates/plan-template.md
- ✅ .specify/templates/spec-template.md
- ✅ .specify/templates/tasks-template.md
- ⚠ .specify/templates/commands/*.md not present in this project
Follow-up TODOs: None
-->
# Pill Reminder Constitution

## Core Principles

### I. Simplicity and Clear Flows
The app MUST make reminder setup, editing, pausing, and confirmation obvious without
requiring accounts, complex configuration, or technical vocabulary. New features
MUST preserve a short primary path for older adults and caregivers. Added
settings, dependencies, services, abstractions, or screens MUST include an
explicit complexity justification in the feature plan.

Rationale: medication reminders lose value when the setup flow is confusing or
too configurable to complete with confidence.

### II. Accessibility for Older Adults
Accessibility is a release requirement. User-facing experiences MUST support
large text, screen readers, sufficient contrast, large touch targets, clear error
recovery, and non-color-only status communication. Feature specs MUST define
accessibility acceptance criteria for each affected flow, and reviews MUST verify
them before release.

Rationale: the primary audience includes older adults who may have low vision,
reduced dexterity, cognitive load sensitivity, or assistive technology needs.

### III. Reliable Local-First Reminders
Core reminder behavior MUST work offline and without an account. Medication
schedules, reminder state, and notification scheduling MUST prefer local device
storage and platform notification APIs unless a feature plan proves that a remote
service is necessary. Reminder changes MUST be deterministic, recoverable after
app restart, and covered by tests for time, recurrence, and permission edge cases.

Rationale: missed or duplicated medication reminders can harm trust and safety,
and internet access cannot be assumed.

### IV. Privacy and User Control
Medication data MUST stay private by default. The app MUST NOT include ads,
tracking, or mandatory accounts for core reminder use. Any analytics, donation,
backup, sync, export, or sharing feature MUST be optional, clearly explained,
minimal in collected data, and documented in the feature spec with storage,
retention, deletion, and user consent behavior.

Rationale: medication details are sensitive health-adjacent information and must
not become a hidden cost of using the app.

### V. Maintainable Architecture
Implementation MUST keep domain rules, notification scheduling, persistence, and
UI presentation separated enough to test and change independently. Code MUST use
Flutter and Dart conventions already present in the repository, keep public APIs
small, avoid speculative abstraction, and document any new architectural layer or
third-party package with a concrete maintenance benefit.

Rationale: a small app can stay dependable only if the code remains easy to read,
test, and evolve.

### VI. Testing as a Release Gate
Behavior that affects reminders, medication data, accessibility states,
localization, permissions, persistence, or privacy MUST have automated tests at
the closest practical level. Every feature MUST include an independently
testable user story, regression tests for fixed defects, and a manual verification
path for platform notification behavior when automation cannot prove it. Changes
MUST pass `flutter test` before merge unless the plan records a temporary blocker.

Rationale: reminder correctness depends on repeatable checks, while platform
notification behavior still needs explicit human validation.

### VII. Consistent, Localizable Experience
User-facing copy, dates, times, medication names, dosage labels, notification
text, and error messages MUST be ready for English and Latin American Spanish.
Features MUST avoid hard-coded user-visible strings in business logic, preserve
consistent navigation and component patterns, and treat empty, loading, error,
and permission-denied states as part of the user experience.

Rationale: consistency lowers cognitive load, and localization readiness prevents
future language support from becoming a disruptive rewrite.

### VIII. Measured Performance
The app MUST start quickly, keep reminder setup responsive, and avoid background
work that drains battery or schedules unnecessary notifications. Feature plans
MUST define measurable performance expectations for affected flows and justify
any polling, background processing, startup work, or large dependency.

Rationale: performance problems are usability problems, especially on older or
lower-cost devices.

## Product and Technical Constraints

- Core use MUST remain account-free, offline-capable, and local-first.
- Donations, if added, MUST be optional, non-intrusive, and separate from core
  reminder completion.
- Dependencies MUST be minimal and justified by user value, reliability,
  accessibility, maintainability, or platform integration needs.
- Data models MUST support future localization, import/export, and user-controlled
  deletion without exposing medication data to unnecessary services.
- Feature plans MUST choose the simplest design that satisfies the user story and
  document rejected simpler alternatives when complexity is added.

## Delivery and Review Standards

- Specifications MUST include prioritized, independently testable user journeys
  and measurable success criteria.
- Plans MUST complete the Constitution Check before design work and repeat it
  after design, covering simplicity, accessibility, reliability, privacy,
  architecture, testing, localization, and performance.
- Task lists MUST include concrete tasks for required tests, accessibility review,
  localization readiness, privacy/data handling, and performance checks whenever
  the feature touches those areas.
- Reviews MUST verify constitution compliance, passing tests, clear user flows,
  and documented complexity exceptions before merge.
- Releases MUST include manual verification for notification scheduling,
  permission handling, and localized user-visible copy when those areas changed.

## Governance

This constitution supersedes conflicting project guidance for product and
engineering decisions. Amendments MUST be made by updating this file, documenting
the Sync Impact Report, updating affected templates or runtime guidance, and
recording the semantic version change.

Versioning follows semantic versioning:
- MAJOR for removing principles or redefining governance in a backward
  incompatible way.
- MINOR for adding principles, sections, required checks, or materially expanded
  guidance.
- PATCH for clarifications, wording fixes, and non-semantic refinements.

Every feature plan, specification, task list, code review, and release decision
MUST consider this constitution. Any exception MUST be documented in the
Complexity Tracking section of the plan with the user value, risk, and simpler
alternative that was rejected.

**Version**: 1.0.0 | **Ratified**: 2026-04-28 | **Last Amended**: 2026-04-28
