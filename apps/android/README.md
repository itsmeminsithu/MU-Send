# MU Send — Android

A phone-to-phone messenger that works with no account and no server. This is the
Android build: a thin native shell around the MU Send web app, which is bundled
offline inside the app. Real WebRTC peer-to-peer chat, pairing by QR code (or a
paste-code fallback), and text / photo / file sending.

Application id: `org.minsithu.musend` · built by Min Sithu (devminsithu)

## Build the APK

You need **Android Studio** (Koala 2024.1 or newer) or a command line with **JDK 17**
and the **Android SDK**. The first build downloads Gradle 8.7 and the Android
dependencies, so it needs internet once; the finished app itself runs offline.

**Android Studio**
1. Open the `mu-send-android` folder.
2. Let it sync (it fetches the Android Gradle Plugin and libraries).
3. Build > Build Bundle(s) / APK(s) > Build APK(s).
4. The APK lands in `app/build/outputs/apk/debug/app-debug.apk`.

**Command line**
```
./gradlew assembleDebug
```
Output: `app/build/outputs/apk/debug/app-debug.apk`.

## Install on a phone
Copy the APK to the phone and open it. You'll be asked to allow installing from
this source the first time. On launch, allow the **camera** permission so you can
scan the pairing QR code.

## How to connect two phones
1. On phone A, tap **Send** — it shows a QR code.
2. On phone B, tap **Receive** and scan phone A's code, then show the reply QR.
3. On phone A, tap **Scan their reply** and scan phone B's code.
That's it — you're connected directly, phone to phone. Then chat, and use the
paperclip to send a photo or file.

## Permissions, and why
- **Camera** — to scan the pairing QR code (you can paste the code instead).
- **Internet** — WebRTC uses a public STUN server to help two phones find each
  other across networks. On the same WiFi it also works without it.

## What's inside
```
app/src/main/
  assets/index.html      the MU Send web app (offline)
  assets/vendor/         bundled libraries (pako, qrcode-generator, jsQR)
  java/.../MainActivity.kt   WebView shell + camera & file-picker bridge
```
The web app is served to the WebView from `https://appassets.androidplatform.net`
via `WebViewAssetLoader`, a secure origin — that's what lets the camera and the
WebRTC data channel run inside a WebView.

## Notes and limits
- This shell reuses the browser stack, so it uses the online (WebRTC) path. Native
  offline transports (Bluetooth, WiFi Direct) would need a Flutter/native rewrite —
  that's the next step on the roadmap.
- The debug APK is unsigned for the Play Store. For a release build, set up a
  signing key in Android Studio (Build > Generate Signed Bundle / APK).

## License
MIT — see LICENSE.
