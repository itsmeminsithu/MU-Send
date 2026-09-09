# MU Send — iOS (SwiftUI + WKWebView)

A native iOS shell that hosts the bundled MU Send web app in a `WKWebView`.
Camera (QR scanning) and the WebRTC data channel work through the web view.

Bundle id: `org.minsithu.musend`

## Build — the easy way (XcodeGen)
XcodeGen turns `project.yml` into a real `.xcodeproj`.
```
brew install xcodegen
cd apps/ios
xcodegen generate
open MuSend.xcodeproj
```
Then pick your device/simulator in Xcode and press Run (Cmd+R).
You need an Apple ID in Xcode > Settings > Accounts to run on a real device.

## Build — the manual way (no XcodeGen)
1. Xcode > File > New > Project > iOS > App. Interface: SwiftUI, Language: Swift.
2. Set the bundle identifier to `org.minsithu.musend`.
3. Delete the generated `ContentView.swift`, then drag in `Sources/MuSendApp.swift`
   and `Sources/WebView.swift` (Copy items if needed).
4. Drag the whole `web` folder in and choose **Create folder references** (blue folder),
   so `web/index.html` and `web/vendor/` stay in place.
5. In the target's Info tab add:
   - Privacy - Camera Usage Description → "MU Send uses the camera to scan the pairing QR code."
   - Privacy - Local Network Usage Description → "MU Send connects two phones directly."
6. Run (Cmd+R).

## Notes
- Requires iOS 15+ (for the WKWebView media-capture permission API).
- Uses the online WebRTC path, same as the web and Android builds.
