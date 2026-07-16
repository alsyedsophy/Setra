# Widget Guidelines

## Responsibility
Widgets display UI only.
Business logic belongs outside Widgets.

## Widget Size
Keep Widgets focused.
Extract Widgets when:
- UI becomes difficult to read.
- UI is reused.
- Widget has a clear responsibility.
Do not extract tiny Widgets unnecessarily.

## Reusability
Reusable Widgets belong in:
core/widgets
Feature-specific Widgets belong inside their feature.
Example:
ProductCard
belongs to
features/products/presentation/widgets
Not core/widgets.

## Build Method
Keep build() readable.
Prefer composition over deeply nested trees.

## Styling
Never hardcode:
- Colors
- TextStyles
- Radius
- Spacing
Always use Design System tokens.

## Strings
Never hardcode visible text.
Always use localization.

## Images
Use cached image widgets.
Always provide:
- Placeholder
- Error Widget

## Lists
Prefer ListView.builder()
GridView.builder()
Never build long lists manually.

## Forms
Use Form.
Validate before submission.
Show validation errors clearly.

## Performance
Use const constructors whenever possible.
Avoid unnecessary rebuilds.
Extract expensive Widgets when needed.

## Accessibility
Buttons must have clear labels.
Touch targets should remain usable.
Support RTL and LTR automatically.