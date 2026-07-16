# Clean Architecture

## Layers

Every feature contains three layers:
Presentation → Domain → Data
Dependencies always point toward Domain.

## Presentation
Contains:
- Screens
- Widgets
- Cubits
- States
Responsibilities:
- Render UI
- Handle user interaction
- Emit states
Presentation MUST NOT:
- Access Firebase
- Access Models
- Implement business rules
Presentation works with Entities only.

## Domain
Contains:
- Entities
- Repository Contracts
- Use Cases
Responsibilities:
- Business rules
- Business validation
Domain MUST NOT depend on:
- Flutter
- Firebase
- Firestore
- Storage
- UI

## Data
Contains:
- Models
- Data Sources
- Repository Implementations
Responsibilities:
- Read data
- Write data
- Map Models ↔ Entities
- Handle external services

## Use Cases
Create a UseCase only when business logic exists.
Good:
CreateOrderUseCase
ApplyCouponUseCase
LoginUseCase
Avoid UseCases that only forward one repository call without adding value.

## Repository
Repository defines business contracts.
Repository Implementation belongs to Data Layer.
Never expose Firebase types outside Data.