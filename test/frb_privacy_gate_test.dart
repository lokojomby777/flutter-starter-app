import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter/core/frb_privacy_gate.dart';

void main() {
  test('defaults deny; user action and permission required', () {
    final gate = FrbPrivacyGate();
    final s = gate.startSession();
    expect(gate.mayCaptureAudio(s), false);
    expect(gate.mayRunOcr(s, userInitiated: true), false);
    gate.updatePermission(s, FrbCapability.camera, FrbPermission.granted);
    gate.updatePermission(s, FrbCapability.ocr, FrbPermission.granted);
    expect(gate.mayRunOcr(s, userInitiated: false), false);
    expect(gate.mayRunOcr(s, userInitiated: true), true);
  });

  test('revocation, session rollover and iOS overlay denial', () {
    final gate = FrbPrivacyGate();
    final s = gate.startSession();
    gate.updatePermission(s, FrbCapability.overlay, FrbPermission.granted);
    expect(gate.mayShowExternalOverlay(s,
      isAndroid: false, systemOverlayAllowed: true), false);
    expect(gate.mayShowExternalOverlay(s,
      isAndroid: true, systemOverlayAllowed: true), true);
    gate.updatePermission(s, FrbCapability.overlay, FrbPermission.denied);
    expect(gate.mayShowExternalOverlay(s,
      isAndroid: true, systemOverlayAllowed: true), false);
    gate.endSession();
    expect(gate.mayCaptureAudio(s), false);
    final next = gate.startSession();
    gate.updatePermission(s, FrbCapability.microphone, FrbPermission.granted);
    expect(gate.mayCaptureAudio(next), false);
  });
}
