# Performance Guidelines

## Goal
Build smooth and scalable applications.
Optimize only when necessary.
Avoid premature optimization.

## Lists
Use:
- ListView.builder
- GridView.builder
Avoid building large lists manually.

## Pagination
Use pagination for collections that may grow.
Never load an entire collection unnecessarily.

## Images
Cache remote images.
Always provide placeholders and error widgets.
Avoid loading full-resolution images when thumbnails are sufficient.

## State Management
Use BlocSelector when only part of the UI changes.
Keep states as small as possible.

## Rebuilds
Minimize widget rebuilds.
Extract widgets only when it reduces rebuild scope.

## Async Operations
Run independent async operations concurrently when appropriate.
Avoid blocking the UI thread.

## Firestore
Request only required documents.
Use indexes for filtered queries.
Avoid unnecessary nested reads.

## Memory
Dispose controllers and subscriptions properly.
Avoid memory leaks.

## Rule
Prioritize readable code.
Optimize only after identifying a real performance issue.