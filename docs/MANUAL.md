# MU Send — build & run manual

Every build reuses the same idea: pair two phones, then chat directly. Pick the
platform you want.

---

## Web (fastest — runs anywhere)
```
cd web
python3 serve.py
```
Open the printed `http://localhost:8000` URL. On a second device on the same
Wi-Fi, open the `http://<lan-ip>:8000` URL and use **Copy/Paste code** to pair
(the camera needs localhost or HTTPS). You can also just open `web/index.html`
directly in a browser.

---

## Android (Kotlin WebView) — `apps/android`
Needs **Android Studio** or **JDK 17 + Android SDK**.

**Android Studio:** open the `apps/android` folder, let Gradle sync, then
Build > Build APK(s). The APK is at
`app/build/outputs/apk/debug/app-debug.apk`.

**Command line / VS Code (macOS example):**
```
# one-time setup (Apple Silicon)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask temurin@17 android-commandlinetools
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
sdkmanager --licenses
echo 'export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.zshrc
source ~/.zshrc

# build & install onto a connected phone (USB debugging on)
cd apps/android
echo "sdk.dir=$ANDROID_HOME" > local.properties
chmod +x gradlew
./gradlew installDebug
```
On first launch, allow the **camera** permission (for scanning the pairing QR).

---

## iOS (Swift WKWebView) — `apps/ios`
Needs **Xcode** on a Mac. See `apps/ios/README.md`. In short:
```
brew install xcodegen
cd apps/ios
xcodegen generate
open MuSend.xcodeproj      # then press Run
```
Or create a new SwiftUI app in Xcode and add the files (manual steps in the iOS
README). Requires iOS 15+.

---

## Flutter (Android + iOS from one codebase) — `apps/flutter`
Needs the **Flutter SDK**. The platform runner folders aren't committed, so
generate them first:
```
cd apps/flutter
flutter create .
flutter pub get
flutter run
```
Then add camera / internet permissions (Android manifest; iOS Info.plist) as
noted in `apps/flutter/README.md`.

---

## Testing the chat
MU Send needs **two devices**. Run any build on two phones (they don't have to be
the same build — web talks to Android, etc.), then pair by scanning each other's
codes. A single device only reaches the connect screen.
