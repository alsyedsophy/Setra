# Enterprise E-Commerce Engineering Guide

This project follows a strict Feature-First Clean Architecture.
Do not redesign the architecture.
Do not introduce new patterns.
Do not replace approved technologies.
Always follow the project documentation before implementing any code.

## Tech Stack

- Flutter
- Firebase
- Cubit
- GetIt
- GoRouter

## Forbidden

- Freezed
- build_runner
- json_serializable
- injectable
- auto_route
- Provider
- Riverpod

## Architecture

Presentation → Domain → Data
Dependencies always point inward.
Presentation → Domain
Data → Domain
Never reverse dependency direction.

## Core Principles

- Keep code simple.
- Avoid overengineering.
- Follow YAGNI.
- Prefer clarity over abstraction.
- One responsibility per class.
- One responsibility per Cubit.

## Feature Development Order

1. Domain
2. Data
3. Presentation
4. Dependency Injection
5. Routing
6. Testing

## Implementation Rules

MUST

- Write production-ready code.
- Handle failures.
- Support localization.
- Support light and dark themes.
- Support responsive layouts.

MUST NOT

- Leave TODOs.
- Write pseudo code.
- Create unused abstractions.
- Access Firebase directly from UI.

Always follow the engineering guide files before implementation.