# Research: Add Medication

## Decision: Build as a Flutter mobile feature for phones and tablets

**Rationale**: The repository is a Flutter app with existing setup flow, localization, theme, and test patterns. A Flutter feature module keeps phones and tablets in one implementation and lets widget tests cover the accessible form behavior.

**Alternatives considered**: Native Android/iOS implementation was rejected because it duplicates UI, validation, accessibility, and localization work. A web-first flow was rejected because the target is the mobile app.

## Decision: Use repository + local JSON storage for v1

**Rationale**: Medication records are local-first, account-free, and small for v1. Persisting a JSON list through a `MedicationRepository` keeps storage simple while preserving a stable interface for a future Firebase-backed repository.

**Alternatives considered**: Direct `shared_preferences` calls from widgets were rejected because they couple UI to persistence. SQLite was rejected because v1 does not need relational queries. Firebase was rejected for v1 because it would conflict with offline/account-free requirements.

## Decision: Keep Firebase as a future repository implementation only

**Rationale**: The user wants a later upgrade path for users and pill information, but this feature must not require accounts, internet, sync, or remote services. A repository boundary lets a future plan add Firebase identity and cloud records without changing the add-medication UI contract.

**Alternatives considered**: Adding Firebase packages now was rejected because it adds remote-service complexity and consent questions outside this feature. Ignoring future Firebase was rejected because it would make later migration more disruptive.

## Decision: Validate text length at 80/80/500 characters

**Rationale**: Medication name 80, dosage label 80, and notes 500 characters are enough for real-world labels and caregiver notes while protecting readability with large text and saved-list layouts.

**Alternatives considered**: 60/60/300 was rejected as too tight for caregiver notes. 120/120/1000 was rejected because it increases layout and review burden without clear v1 value.

## Decision: Allow duplicate names with gentle confirmation

**Rationale**: Duplicate medication names can be legitimate when dosage labels or notes differ. A non-blocking confirmation helps catch accidental duplicates without making medical assumptions.

**Alternatives considered**: Blocking duplicates was rejected because it could prevent valid records. Allowing duplicates silently was rejected because accidental duplicate entry is likely for older adults and caregivers.

## Decision: Keep medication scheduling out of scope

**Rationale**: The feature stores medications for future reminders, but schedule creation, notification scheduling, recurrence, refill tracking, and reminder delivery are separate workflows. The add-medication feature only needs to make active medications available for future reminder setup.

**Alternatives considered**: Combining medication entry and reminder scheduling was rejected because it would lengthen the primary path and increase cognitive load.
