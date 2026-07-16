# Coding Standards

## General
Code must be readable before being clever.
Prefer simplicity.
Avoid unnecessary abstractions.

## Classes
One class = one responsibility.
Keep classes focused.
Split large classes when responsibilities grow.

## Methods
Methods should do one thing.
Avoid long methods.
Extract private methods when logic becomes difficult to read.

## Variables
Use meaningful names.
Avoid abbreviations.
Bad:
```
p
x
tmp
```
Good:
```
product
selectedVariant
currentUser
```
## Constants
Never hardcode values repeatedly.
Move reusable values to constants or design tokens.

## Null Safety
Always embrace null safety.
Avoid using `!` unless absolutely certain.
Prefer safe code over shortcuts.

## Comments
Do not explain what the code does.
Write self-explanatory code.
Use comments only for business rules or complex decisions.

## Error Handling
Never ignore exceptions.
Every external operation must handle failures.
Never return null to indicate failure.
Use Failure objects instead.

## Formatting
Keep consistent formatting.
Use trailing commas where appropriate.
Prefer short widget trees by extracting reusable widgets.

## Quality Rule

Before finishing any implementation ask:
- Is this simple?
- Is this maintainable?
- Does it follow the architecture?
- Is there unnecessary code?
If the answer to the last question is yes, simplify it.