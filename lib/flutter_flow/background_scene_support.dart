import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// `webview_flutter` only ships platform implementations for Android and
/// iOS, so the animated three.js background must stay off everywhere else
/// (web, Windows, macOS, Linux) or it throws at runtime.
bool get supportsBackgroundScene3D =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
