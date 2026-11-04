# FRB independent app — integration acceptance matrix (2026-11-04)

Status: specification only; no native device execution claimed. Additive document on isolated architecture branch. Do not alter approved assets, JOMBY, NEXXO, FREEBIES or main.

## Integration contracts and ownership
- Architecture task owns compatibility matrix, test fixtures and acceptance evidence; UI/voice task owns implementations. FREEBIES stays independent.
- Every command carries ownerId, sessionId, locale es-PR, requestId and monotonic event revision. Storage and sync enforce owner scope on reads and writes; server authorization must not trust client-supplied ownerId.
- Capability broker returns supported, denied, restricted, unavailable or requires_settings; denied/revoked capability must not trigger silent retries or unexpected Settings navigation.
- Sensitive voice transcripts and OCR data remain ephemeral unless user explicitly saves; redact logs; never store access tokens in plain preferences.
- Reminder scheduler stores IANA timezone, local wall time, recurrence, and stable idempotency key; reconcile after DST, reboot and permission changes.
- Offline sync queues encrypted owner-scoped mutations; tombstones survive retry; concurrent edits require deterministic conflict policy and no cross-user merge.

## Executable acceptance scenarios to implement
| ID | Modules | Input / transition | Required evidence |
|---|---|---|---|
| INT-01 | Voice → Notes → Storage | es-PR “nota” twice with same requestId | Exactly one encrypted note, correct owner |
| INT-02 | Voice → Reminder → OS | “recuérdame” with timezone, deny notifications | Saved pending reminder, explicit delivery-unavailable status |
| INT-03 | Permissions → Voice | Revoke mic while recording | Capture stops, no orphan recorder or transcript leak |
| INT-04 | OCR → Translate → Clipboard | OCR text then translate offline | Supported offline result or explicit unavailable; no fabricated translation |
| INT-05 | GPS → Nearby → Navigation | Deny location / restore foreground | No location leak; navigation requires user action |
| INT-06 | Session → Storage → Sync | Switch account while queued offline mutation | No cross-account read, write, or upload |
| INT-07 | Sync → Retention | Delete offline, reconnect with stale remote revision | Tombstone wins per documented policy; no resurrection |
| INT-08 | Scheduler → OS | DST forward/back, timezone change, reboot | Deterministic next trigger and documented OS limitations |
| INT-09 | Bluetooth → Voice | Disconnect while dictating | Safe audio route fallback, no accidental command |
| INT-10 | Android overlay → Permissions | Grant, revoke, lock screen, process death on Motorola | No unauthorized overlay; recovery state consistent |
| INT-11 | iOS panel → Background | App backgrounded during dictation | In-app panel not falsely presented as system overlay |
| INT-12 | Notifications → Session | Tap notification after logout | Requires reauthentication; no private content exposed |
| INT-13 | Storage → Export | Export selected important notes | Owner-scoped, explicit destination, integrity verified |
| INT-14 | Capability → Media | Request flashlight/media action unsupported | Explicit unavailable; no unrelated permission escalation |

## Platform release gates
Android: confirm OS version, overlay special access, foreground-service type/policy, notification permission, exact-alarm eligibility and OEM battery restrictions on target Motorola; no assumption of continuous background microphone. iOS: no global floating window across apps; use in-app surface and only supported widgets/Live Activities; verify background task and notification behavior on physical iPhone.

## Evidence required for pass
Record commit SHA, platform/OS, device model, test ID, steps, expected/actual, timestamp, logs with secrets redacted, and artifact checksum. Unit or mock pass must be labeled simulation. Native pass requires a real device or documented emulator and must not be inferred from this specification.

## Owner approval gates (defer until required)
Approved official medallion asset for visual release; account decisions only for actual App Store/Play distribution; map/speed-limit licensing before enabling sourced speed-limit claims; privacy and retention policy before external beta. No owner action currently required.
