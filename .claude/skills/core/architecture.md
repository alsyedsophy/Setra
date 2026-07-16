# Architecture

## Architecture Style

Feature-First Clean Architecture.
Project Structure:
features/
core/
Every feature contains:
- presentation
- domain
- data

## Layer Responsibilities

### Presentation

Contains:
- Screens
- Widgets
- Cubits
- States
Presentation must not access Firebase.
Presentation must not access Models.
Presentation works with Entities only.

---

### Domain

Contains:
- Entities
- Repository Contracts
- Use Cases
Domain is pure business logic.
Domain must not depend on Flutter.
Domain must not depend on Firebase.
---

### Data

Contains:
- Models
- Data Sources
- Repository Implementations

Data is responsible for:
- Reading data
- Writing data
- Mapping models
- Handling external services

---

## Dependency Rules

Allowed:
Presentation → Domain
Data → Domain

Forbidden:
Domain → Presentation
Domain → Data
Core → Features
---

## Firebase Rule

Firebase is only a data source.
The application must not depend on Firebase directly.
If Firebase is replaced later:
- Domain remains unchanged.
- Presentation remains unchanged.
Only Data Layer changes.

---

## Feature Isolation

Features must be independent.
Authentication must not depend on Cart.
Cart must not depend on Orders.
Communication between features should happen through repositories or shared services.
Avoid feature-to-feature coupling.