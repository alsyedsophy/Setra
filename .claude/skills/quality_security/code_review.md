# Code Review Checklist

## Architecture
- Does the feature follow Clean Architecture?
- Are dependencies pointing inward?
- Is Firebase isolated in the Data layer?
- Are feature boundaries respected?

## Code Quality
- Is the code simple and readable?
- Does every class have one responsibility?
- Are methods small and focused?
- Is there any duplicated code?

## Flutter
- Are widgets kept small?
- Are const constructors used when possible?
- Is business logic outside the UI?
- Are Design System tokens used?

## State Management
- Does each Cubit have one responsibility?
- Are state transitions clear?
- Are Failures handled correctly?
- Are unnecessary rebuilds avoided?

## Localization
- Are all visible strings localized?
- Does the screen support RTL and LTR?

## Responsive
- Does the UI work on:
  - Mobile
  - Tablet
  - Desktop

## Performance
- Are large lists paginated?
- Are images cached?
- Are unnecessary Firestore reads avoided?

## Testing
- Are the required tests included?
- Are edge cases covered?
---
A feature is complete only if every item above is satisfied.