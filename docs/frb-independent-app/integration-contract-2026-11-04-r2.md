# FRB independent app: integration architecture revision 2 (2026-11-04)

Scope: unnamed standalone app. No changes to JOMBY, NEXXO, FREEBIES or original assets. This is a specification, not a mobile build.

## Platform limits
- Android: overlays need explicit special permission; foreground services, microphone and location are constrained by OS version and background launch rules.
- iPhone: third-party persistent cross-app floating windows are not supported. Use an in-app panel, notifications and supported system integrations instead.
- Screen reading: Android capture requires explicit user consent; iOS cannot silently read arbitrary other apps. Offer share sheet or imported image OCR.
- GPS: foreground location first; background access requires separate justification and permission. Never fabricate posted speed limits.
- Voice: push-to-talk baseline; no promise of unrestricted always-listening operation.
- Reminders: handle notification denial, Android exact alarm eligibility and iOS notification scheduling restrictions.

## Modules and contracts
Flutter UI; session/account boundary; encrypted local storage; notes and lists; reminders; speech; translation; OCR; GPS; permission gateway; platform adapters. Every data operation carries account and session identifiers. Account changes invalidate caches and pending callbacks. Permission revocation terminates active capture and streams. Reminders are idempotent and timezone-aware. OCR text is ephemeral until explicitly saved. Platform adapters return supported, permission_required, unavailable or unsupported.

## Integration test matrix
1. Account/storage: cross-account isolation, logout race, stale callbacks, backup restore.
2. Notes/reminders: create/update/delete, daylight-saving change, reboot, denied notifications, duplicate alarms.
3. Speech/translation/OCR: interruption, offline error, language choice, revoked consent, no unintended retention.
4. GPS/overlay: unknown road limit, background transition, denied overlay, battery restrictions.
5. Device acceptance: Motorola Android and iPhone builds, permission prompts, Bluetooth, accessibility, crash recovery.

## Release gate
Require signed installable builds, integration results on both actual devices, reviewed privacy text and dependency licenses before calling the app ready. No paid service, developer account or external SDK activated without owner permission.

## Future owner dependencies
Store publication would require Apple and Google developer enrollment and applicable fees; not required for architecture work. Final medallion artwork and its usage approval are needed before final branded screens. iPhone cross-app overlay is not a viable requirement and must use the documented fallback.
