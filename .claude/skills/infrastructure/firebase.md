# Firebase Guidelines

## Firebase Role
Firebase is a Data Source only.
Never let Firebase leak outside the Data Layer.

## Authentication
Use Firebase Authentication.
Authentication logic belongs to RemoteDataSource.
Repositories expose business-friendly methods.
Never expose FirebaseUser.

## Firestore
Collections must follow project naming.
Never query Firestore from Cubits.
Never query Firestore from Widgets.
Always use:
Repository → RemoteDataSource → Firestore

## Storage
Product images are stored in Firebase Storage.
Profile images are stored separately.
Never expose Storage APIs outside Data.

## Cloud Messaging
FCM belongs to Core Services.
Features receive notifications through repositories or services.

## Crashlytics
Unexpected exceptions should be reported.
Expected business failures should NOT be reported.
Examples:
Wrong password
Invalid coupon
Network timeout
These are handled as Failures.

## Analytics
Analytics is optional.
Keep tracking calls isolated inside services.
Never spread analytics code across widgets.

## Mapping
Firebase Models → Domain Entities → Presentation
Never return Firebase snapshots directly.
Never expose DocumentSnapshot outside Data Layer.

## Offline
Firestore offline persistence may be enabled.
Application logic must not depend on it.
Offline cache is an optimization, not a business rule.