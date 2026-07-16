# Testing Guidelines

## Goal
Test business logic, not Flutter itself.
Focus on reliability and maintainability.

## Test Types
Use:
- Unit Tests
- Repository Tests
- Cubit Tests
- Widget Tests
Integration Tests are optional for MVP.

## Unit Tests
Test:
- Validators
- Helpers
- Business rules
- Complex UseCases
Avoid testing simple getters or setters.

## Repository Tests
Verify:
- Data mapping
- Failure handling
- Repository behavior
Use mocked Data Sources.

## Cubit Tests
Verify:
- Initial state
- State transitions
- Failure scenarios
- Success scenarios
Do not test UI here.

## Widget Tests
Test critical screens and reusable widgets.
Verify user interaction and rendering.
Avoid testing visual styling.

## Rule
Every completed feature should include the appropriate tests before it is considered done.