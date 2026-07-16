# Responsive Guidelines

## Goal
Support:
- Mobile
- Tablet
- Desktop
Using one codebase.

## Breakpoints
Use centralized breakpoints.
Never compare screen width manually inside screens.

## Layout
UI adapts using the Responsive System.
Avoid random MediaQuery usage.

## Navigation
Mobile
Bottom Navigation
Tablet
Navigation Rail
Desktop
Side Navigation

## Grid
Grid columns change by breakpoint.
Never hardcode item counts.

## Spacing
Spacing scales with screen size.
Do not multiply values manually.

## Typography
Typography adapts automatically.
Do not change font sizes per screen.

## Images
Images scale while preserving aspect ratio.
Avoid fixed dimensions whenever possible.

## Dialogs
Dialogs should adapt to screen width.
Desktop dialogs must not occupy the entire screen.

## Performance
Do not build separate screens for every device.
Reuse layouts whenever possible.

## Rule
Every new screen must work correctly on:
- Mobile
- Tablet
- Desktop
before it is considered complete.