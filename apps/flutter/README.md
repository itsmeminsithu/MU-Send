# MU Send — Flutter (Android + iOS from one codebase)

The native cross-platform build. This is the path that can later reach the
**offline** radios (Bluetooth, WiFi Direct, Nearby/Multipeer) that a WebView
can't — for now it implements the same online WebRTC pairing + chat.

Bundle / application id: `org.minsithu.musend`

## This is a source scaffold
To keep the repo small, the generated `android/` and `ios/` runner folders are
**not** committed. Generate them, then run:

```
cd apps/flutter
flutter create .          # generates android/ and ios/ runners for this project
flutter pub get
flutter run               # with a device or emulator connected
```

`flutter create .` reads `pubspec.yaml` and creates the platform folders around
the existing `lib/`, keeping your code. Set the id when you first create, or edit
`android/app/build.gradle` (applicationId) and the iOS bundle id in Xcode to
`org.minsithu.musend`.

## Permissions to add after `flutter create`
- **Android** `android/app/src/main/AndroidManifest.xml`: `CAMERA` and `INTERNET`.
- **iOS** `ios/Runner/Info.plist`: `NSCameraUsageDescription`,
  `NSLocalNetworkUsageDescription`.

## Layout
```
lib/
  main.dart                    app entry + theme
  theme.dart                   colours (teal / violet / amber)
  core/signal.dart             SDP <-> pairing code
  transport/webrtc_transport.dart   the swappable transport (WebRTC data channel)
  screens/connect_screen.dart  Send / Receive
  screens/show_code_screen.dart  show your QR / scan the reply
  screens/scan_screen.dart     camera QR scanner (+ paste fallback)
  screens/chat_screen.dart     chat, photos, files
```
