# Flutter Guidelines

## Widgets
Prefer StatelessWidget.
Use StatefulWidget only when local mutable state is required.
Never use StatefulWidget for business logic.

## Build Method
Keep build() clean.
Move complex UI into private widgets.
Avoid deeply nested widget trees.

## Const
Use const whenever possible.
This improves rebuild performance.

## BuildContext
Use BuildContext only inside Presentation.
Never pass BuildContext to Domain or Data layers.

## Business Logic
Widgets must not contain business logic.
Widgets only display state and forward user actions.
Business logic belongs to Cubits and UseCases.

## Firebase
Never access Firebase directly from Widgets.
Always go through:
Cubit → UseCase → Repository → Data Source → Firebase

## Navigation
Use GoRouter only.
Never use Navigator directly unless there is a justified exception.
Navigation must stay in Presentation.

## Forms
Use Form widgets.
Validate before executing business logic.
Never duplicate validation rules.

## Responsive UI
Do not use random MediaQuery checks.
Always use the project's responsive system.

## Themes
Never hardcode colors.
Never hardcode text styles.
Always use Design System tokens.

## Strings
Never hardcode user-facing text.
Every visible string must come from localization.

## Performance
Prefer lazy builders.
Avoid rebuilding large widget trees.
Use BlocSelector when only part of the state changes.

## Reusability
Extract reusable widgets only after real duplication.
Do not create reusable widgets prematurely.