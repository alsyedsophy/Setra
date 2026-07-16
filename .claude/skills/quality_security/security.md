# Security Guidelines

## General
Security is mandatory.
Never trade security for convenience.

## Authentication
Use Firebase Authentication only.
Never trust client authentication alone.
Always verify user identity in Security Rules.

## Firestore
Access Firestore through repositories only.
Never expose unrestricted reads or writes.
Use Firestore Security Rules for authorization.

## Storage
Protect Storage using Storage Rules.
Users may only access files they are authorized to read or write.
Never store sensitive data in Storage metadata.

## Validation
Validate input at every layer.
Presentation validates user input.
Domain validates business rules.
Firestore Rules validate permissions.

## Secrets
Never hardcode:
- API Keys
- Tokens
- Secrets
Use environment configuration when needed.

## Logging
Never log:
- Passwords
- Tokens
- Personal information
Logs should contain only debugging information.

## Payments
Never trust payment results from the client.
Always verify payment status before creating an order.

## Rule
Every new feature must be reviewed for security before release.