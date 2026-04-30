# ux-design.md

## Overview

Design a **calm, accessible onboarding flow** for an offline pill reminder app aimed at older adults. The experience should feel reassuring, simple, and private—avoiding clinical or technical language.

### Core Principles

* One decision per screen
* Large, readable text and touch targets
* Warm, non-medical visual tone
* Clear, pressure-free choices
* No required account or setup friction

---

# 1. Screen: Language Selection

## Purpose

Allow users to choose their preferred language immediately and confidently.

## Layout

* Vertical stack, centered
* Top margin: 64px
* Side padding: 24px

### Structure

1. Title (top)
2. Spacer (24px)
3. Language buttons (stacked, full width)
4. Bottom safe area padding (32px)

## Content

* Title: “Choose your language”
* Buttons:

  * “English”
  * “Español (Latinoamérica)”

## Components

### Language Button

* Height: 56px minimum
* Width: 100%
* Border radius: 14px
* Padding: 16px horizontal
* Text size: 20–22pt

#### States

* Default: light background, dark text
* Selected: soft green background + check icon
* Pressed: slightly darker shade
* Focus (accessibility): visible outline

## Interaction

* Tap selects language immediately
* Visual confirmation (highlight + checkmark)
* Automatically advances to next screen

---

# 2. Screen: Privacy Explanation

## Purpose

Build trust by clearly explaining that no account or data sharing is required.

## Layout

* Vertical stack
* Top illustration
* Centered text block
* Bottom primary button (sticky)

### Structure

1. Illustration (top, ~120–160px height)
2. Spacer (24px)
3. Title
4. Spacer (12px)
5. Body text
6. Spacer (32px)
7. Primary button (bottom aligned)

## Content

* Title: “Your information stays with you”
* Body:

  * “Your medication reminders are saved only on this device.”
  * “No account. No sharing.”
* Button: “Continue”

## Components

### Illustration

* Style: soft, friendly (shield, notebook, or lock)
* Avoid medical imagery (no pills, syringes, hospitals)

### Primary Button

* Height: 56px
* Full width
* Background: soft green
* Text: white
* Border radius: 14px

#### States

* Default: solid fill
* Pressed: darker green
* Disabled: reduced opacity (still readable)

---

# 3. Screen: Notification Permission

## Purpose

Ask for notification access while allowing users to continue without enabling it.

## Layout

* Vertical stack
* Text centered
* Two buttons stacked

### Structure

1. Title
2. Spacer (12px)
3. Body text
4. Spacer (32px)
5. Primary button
6. Spacer (12px)
7. Secondary button

## Content

* Title: “Get reminder alerts”
* Body: “We can remind you when it’s time to take your medication.”
* Primary: “Turn on reminders”
* Secondary: “Not now”

## Components

### Primary Button

* Same as previous screen

### Secondary Button

* Height: 56px
* Full width
* Style: outline or light gray fill
* Text: dark gray

#### States

* Default: neutral
* Pressed: slightly darker
* Focus: visible outline

## Interaction

* “Turn on reminders” → triggers OS permission dialog
* “Not now” → proceeds without blocking
* No warnings or negative feedback

---

# Visual Styling

## Color Palette

### Background

* Warm off-white: #F7F6F3

### Primary

* Soft green: #6FAF8F

### Secondary

* Muted blue: #7FA7C6

### Accent

* Warm beige: #E8D8C3

### Text

* Primary: #2F2F2F
* Secondary: #6B6B6B

## Guidelines

* Avoid pure white backgrounds
* Avoid harsh contrast combinations
* No red warnings during onboarding

---

# Typography

## Font

* Sans-serif, highly legible

## Sizes

* Title: 24–28pt
* Body: 18–20pt
* Buttons: 20–22pt

## Rules

* Minimum text size: 16pt
* Sentence case only
* No condensed fonts
* Generous line height (1.4–1.6)

---

# Spacing System

## Base Unit

* 8px grid

## Standard Spacing

* Small gap: 8px
* Medium gap: 16px
* Large gap: 24px
* Section gap: 32px

## Layout Margins

* Horizontal: 20–24px
* Vertical top: 48–64px

---

# Iconography

## Style

* Simple, rounded, friendly
* Line or soft fill
* No sharp edges

## Usage

* Always paired with text
* Examples:

  * Shield (privacy)
  * Bell (notifications)
  * Checkmark (selection)

---

# Accessibility Requirements

## Text & Readability

* Minimum contrast: WCAG AA
* Large default text (no scaling required)
* Avoid light gray on white

## Touch Targets

* Minimum height: 48px (preferred 56px)
* Full-width buttons

## Interaction

* No time-based actions
* No hidden gestures
* Clear labels (avoid vague terms like “Allow”)

## Screen Reader Support

* Buttons must have descriptive labels:

  * “Turn on reminders”
  * “Continue without reminders”
* Logical reading order (top → bottom)

## Cognitive Accessibility

* One decision per screen
* No technical jargon
* No error states during onboarding

---

# Mobile-First Considerations

## Layout

* Single column only
* Avoid scrolling when possible
* Keep content within thumb reach

## Navigation

* Linear flow only (no branching)
* Back navigation optional but not required

## Buttons

* Primary actions near bottom of screen
* Sticky positioning preferred

---

# Component Summary

## Buttons

* Primary (filled)
* Secondary (outline or soft fill)

## Text Blocks

* Title
* Body (short, max 2 lines per paragraph)

## Illustrations

* Friendly, non-medical

## Icons

* Supporting only (never standalone)

---

# States Overview

## Buttons

* Default
* Pressed
* Focused
* Disabled

## Selection (Language)

* Default
* Selected (highlight + checkmark)

---

# Implementation Notes

## Behavior

* Language selection persists immediately
* No backend or account logic required
* All data stored locally

## Notifications

* Use system permission dialog
* Do not block progression if denied

## Performance

* Instant transitions (no heavy animations)
* Subtle fades only (150–200ms)

## Error Handling

* Avoid errors in onboarding
* Always allow forward progress

---

# Tone & Copy Guidelines

## Voice

* Calm, friendly, reassuring
* Direct and simple

## Avoid

* Technical terms (e.g., “data”, “encryption”)
* Clinical language
* Urgency or pressure

## Preferred Style

* “We can remind you…”
* “Your information stays with you”

---

# Final UX Goal

The user should feel:

* Safe (privacy is clear)
* In control (choices are optional)
* Comfortable (nothing confusing or rushed)

If any screen feels:

* Crowded → increase spacing
* Technical → simplify wording
* Cold → add warmth (color or illustration)

**Success = immediate understanding + zero hesitation to continue**
