# Dependency Injection

## Container
Use GetIt.
No other DI framework is allowed.

## Registration
Each feature registers its own dependencies.
Avoid a single large registration file.
Example:
registerAuthentication()
registerProducts()
registerOrders()

## Registration Order
Always register in this order:
Data Sources → Repositories → Use Cases → Cubits

## Lifetime
Singleton
Use for shared services.
Examples:
FirebaseAuth
Firestore
Logger
---
Lazy Singleton
Use for repositories and data sources.
Create only when first needed.
---
Factory
Use for Cubits.
Each screen receives a new Cubit instance.

## Dependencies
Inject dependencies through constructors.
Never create dependencies using:
new
inside classes.
Never call GetIt inside business logic.

## Testing
Dependencies must be replaceable with mocks.
Avoid tightly coupled implementations.

## Rules
One registration method per feature.
Keep registration files small.
Remove unused registrations.
Avoid service locators inside Features.