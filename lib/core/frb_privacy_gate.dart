/// FRB experimental privacy boundary. Not wired to production services.
/// Never store recognized text, images, audio or credentials in this object.
enum FrbCapability { microphone, camera, ocr, translation, overlay }
enum FrbPermission { unknown, granted, denied, restricted, unavailable }

class FrbPrivacyGate {
  final Map<FrbCapability, FrbPermission> _permissions = {};
  int _session = 0;
  bool _active = false;

  int startSession() {
    _session += 1;
    _active = true;
    _permissions.clear();
    return _session;
  }

  void endSession() {
    _session += 1;
    _active = false;
    _permissions.clear();
  }

  void updatePermission(int session, FrbCapability capability,
      FrbPermission permission) {
    if (!_active || session != _session) return;
    _permissions[capability] = permission;
  }

  bool mayCaptureAudio(int session) =>
      _allowed(session, FrbCapability.microphone);

  bool mayCaptureImage(int session) =>
      _allowed(session, FrbCapability.camera);

  bool mayRunOcr(int session, {required bool userInitiated}) =>
      userInitiated &&
      _allowed(session, FrbCapability.ocr) &&
      _allowed(session, FrbCapability.camera);

  bool mayTranslate(int session, {required bool userInitiated}) =>
      userInitiated && _allowed(session, FrbCapability.translation);

  bool mayShowExternalOverlay(int session,
      {required bool isAndroid, required bool systemOverlayAllowed}) =>
      isAndroid &&
      systemOverlayAllowed &&
      _allowed(session, FrbCapability.overlay);

  bool _allowed(int session, FrbCapability capability) =>
      _active &&
      session == _session &&
      _permissions[capability] == FrbPermission.granted;
}
