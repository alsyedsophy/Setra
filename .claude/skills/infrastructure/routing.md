# Routing Guidelines

## Router
Use GoRouter only.
Do not use Navigator directly unless explicitly approved.

## Responsibility
GoRouter manages navigation only.
Business logic must not exist inside routing.

## Route Organization
Routes should be grouped by feature.
Example:
- Authentication
- Home
- Products
- Cart
- Orders
- Profile
Avoid one huge routes file.

## Guards
Use route guards for:
- Authentication
- Protected screens
Do not place permission logic inside screens.

## Parameters
Use path parameters for resource IDs.
Example:
/products/:productId
Use query parameters only for optional values.

## Navigation
Navigation must happen from Presentation.
Cubits never navigate.
Use UI callbacks to trigger navigation.

## Deep Links
Routes must support deep linking.
Screen initialization should depend only on route parameters.

## Naming
Keep route names descriptive.
Avoid generic names like:
page1
screen2
route3

## Errors
Provide a fallback error page.
Do not crash on invalid routes.

## Consistency
Use the same navigation style across the project.
Do not mix navigation approaches.