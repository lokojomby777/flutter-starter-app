# FRB independent app architecture — 2026-11-04
Design-only; not a mobile build. This branch is isolated from main, JOMBY, NEXXO and FREEBIES.

## Architecture
Flutter UI and accessibility (es-PR) → domain commands/events → platform capability adapters (Android/iOS) → encrypted offline-first per-user storage and optional authenticated sync. Modules: identity/session, notes/lists, reminders/alarms, voice/TTS, translation, OCR, GPS/navigation, floating panel, media/Bluetooth/flashlight, permission broker, sync, retention/export.

## Platform limits
Android overlays require special permission and vary by OEM; foreground services require suitable service types and visible notifications; exact alarms and background location are restricted. iOS does not permit a universal overlay above other apps: use an in-app panel, widgets/Live Activities only where appropriate. Background execution and wake-word listening are limited. Do not promise permanent microphone access or speed-limit data without licensed source.

## Contracts
CapabilityResult(platform, feature, status: supported|denied|restricted|unavailable|requires_settings, rationale).
VoiceIntent(sessionId, locale, transcript, type, payload, confidence, idempotencyKey).
Reminder(id, ownerId, localSchedule, timezone, recurrence, deliveryStatus).
SyncRecord(ownerId, recordId, revision, tombstone, encryptedPayload).
Reject any cross-owner merge. Revoking permission cancels associated observers and background work. Logout clears ephemeral data.

## Integration tests required
Voice→note→encrypted save→sync; voice→reminder→system notification; OCR→translation→copy; GPS→nearby→external navigation; account switch isolation; revoked microphone/location during session; offline sync/retry; timezone/DST and reboot; Bluetooth disconnect; Android Motorola overlay lifecycle; physical iPhone notification/in-app panel. No device tests claimed.

## Owner gates (not needed now)
Approved medallion/icon before visual release; Apple Developer membership before iOS distribution; Google Play account only if publishing through Play; map/speed-limit data licensing before shipping those features; privacy policy and retention decisions before public beta.

## Preservation
No changes to approved originals or other projects. Architecture remains a proposal until implementation and physical-device verification. Integration coordination remains within architecture task; FREEBIES remains independent.
