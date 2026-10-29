# MU Send

MU Send is a phone-to-phone messenger. There is no account and no server. You pair two phones by scanning each other's QR code, then chat and send photos and files straight from one device to the other, over the internet or the same Wi-Fi.

Built by **Min Sithu** (`devminsithu`) · id `org.minsithu.musend` · MIT licensed.

## Files

```
mu-send/
├── README.md              you are here
├── LICENSE                MIT
├── docs/
│   ├── ABOUT.md           what MU Send is and how it works
│   ├── MANUAL.md          build & run steps for every platform
│   ├── DEVELOPER.md       developer / contact info
│   └── BUILD_PLAN.md      architecture + offline roadmap
├── web/                   the web app (runs today) + a local server
└── apps/
    ├── android/           native Android (Kotlin + WebView) — buildable APK
    ├── ios/               native iOS (Swift + WKWebView) — Xcode project config
    └── flutter/           cross-platform (Dart) — source scaffold
```

## Run the web version

```
cd web && python3 serve.py
```

Open the `localhost` URL it prints. One device on its own is not enough to test a chat: open the same app on a second device and pair by scanning each other's codes.

Android, iOS and Flutter builds are in **`docs/MANUAL.md`**.

## Where each build stands

| Build | Stack | State |
|-------|-------|-------|
| Web | HTML + JS | Complete, runs today |
| Android | Kotlin + WebView | Complete, buildable APK |
| iOS | Swift + WKWebView | Source + XcodeGen/manual setup |
| Flutter | Dart | Source scaffold (`flutter create .` to build) |

The web and WebView builds connect over WebRTC. The offline radios (Bluetooth, Wi-Fi Direct, Nearby/Multipeer) are not in yet. They are the next milestone, on the Flutter/native path — see `docs/BUILD_PLAN.md`.

## About a live preview

The web app is static: `web/index.html` plus vendored JS. Pairing is serverless — the connection code is swapped by QR code or paste (see `web/index.html` and `docs/ABOUT.md`) — so no app server is needed to run it locally:

```
cd web && python3 serve.py
```

There is no Pages preview for it here, and no preview URL is live. GitHub Pages can only serve the repo root or `/docs` with the branch-folder setting; it cannot point at `web/`. Options after merge: add a Pages Actions workflow that deploys `web/`, through the GitHub web UI (workflow files cannot be pushed via the Muse GitHub App, so that step is not in this PR), or serve `web/` from any static host.

## License

MIT — see [LICENSE](LICENSE).
