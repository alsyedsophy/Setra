# Localization Guidelines

## Languages
The application supports:
- English
- Arabic
Every feature must support both languages.

## Strings
Never hardcode user-facing text.
Always use localization resources.
Bad:
Text("Login")
Good:
Text(context.l10n.login)

## RTL
The application must fully support:
- RTL
- LTR
Never force text direction.
Flutter should determine direction automatically.

## Keys
Localization keys must be descriptive.
Good:
loginTitle
checkoutButton
orderStatusDelivered
Avoid:
text1
title2
msg3

## Interpolation
Use placeholders for dynamic values.
Example:
Welcome, {name}
Never concatenate localized strings.

## Dates & Numbers
Format dates, currency, and numbers based on locale.
Avoid manual formatting.

## Validation Messages
Validation errors must come from localization.
Never hardcode validation messages.

## Rule
Every new screen must be verified in both:
- English
- Arabic