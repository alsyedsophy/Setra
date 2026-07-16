# Cubit Guidelines

## Responsibility
Each Cubit has one responsibility only.
Good:
- LoginCubit
- CartCubit
- ProductsCubit
Avoid Cubits that manage multiple features.

## Business Logic
Business logic belongs inside UseCases.
Cubits coordinate application flow.
Cubits call UseCases.
Cubits emit States.

## Dependencies
Cubit depends only on:
- UseCases
- Domain Entities
Never inject:
- Firebase
- Firestore
- DataSources

## States
Every Cubit should expose clear states.
Typical flow:
Initial → Loading → Success → Failure
Avoid unnecessary states.

## State Content
States should contain only UI data.
Do not expose Models.
Expose Entities only.

## Navigation
Cubits must never navigate.
Do not use:
context.go()
Navigator.push()
inside Cubits.
Navigation belongs to Presentation.

## Validation
Input validation belongs to:
Validators
or
UseCases
Do not duplicate validation inside Cubits.

## Error Handling
Catch Failures only.
Never catch FirebaseException.

## Lifetime
Create Cubits using GetIt Factory.
Dispose Cubits with the screen lifecycle.

## Performance
Use BlocSelector when only part of the state changes.
Avoid rebuilding entire screens.