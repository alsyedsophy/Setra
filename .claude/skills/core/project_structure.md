# Project Structure

The project follows a Feature-First structure.
```
lib/

├── app/
├── core/
├── features/
├── firebase_options.dart
└── main.dart
```

## app/

Contains application bootstrap.
Allowed:
- app.dart
- dependency_injection.dart
- router.dart
Must NOT contain business logic.

## core/

Contains shared infrastructure.
Examples:
- config
- design_system
- errors
- extensions
- localization
- routing
- services
- storage
- theme
- utils
- validators
- widgets
Core must never depend on any feature.

## features/

Each feature owns its code.
Example:

features/
authentication/
home/
products/
cart/
orders/
Every feature contains:
feature/
presentation/
domain/
data/

No layer may be skipped.

## Presentation

Contains:
- cubit
- screens
- widgets

## Domain

Contains:
- entities
- repositories
- usecases

## Data

Contains:
- models
- datasources
- repositories

## Imports
Feature imports:
Feature → Core
Never:
Core → Feature
Never import files from another feature unless explicitly approved.
Always keep features isolated.