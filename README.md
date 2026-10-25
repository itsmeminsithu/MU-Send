# MU Send

A phone-to-phone messenger with **no account and no server**. Pair two phones by
scanning each other's QR code, then chat and send photos and files directly,
device to device — over the internet or the same Wi-Fi.

Built by **Min Sithu** (`devminsithu`) · id `org.minsithu.musend` · MIT licensed.

---

## What's in here

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

## Quick start (web — no tools needed)
```
cd web && python3 serve.py
```
Open the printed `localhost` URL. To see a real chat you need it on a second
device too — open the same app there and pair by scanning each other's codes.

For Android, iOS, and Flutter builds, see **`docs/MANUAL.md`**.

## Status
| Build | Stack | State |
|-------|-------|-------|
| Web | HTML + JS | Complete, runs today |
| Android | Kotlin + WebView | Complete, buildable APK |
| iOS | Swift + WKWebView | Source + XcodeGen/manual setup |
| Flutter | Dart | Source scaffold (`flutter create .` to build) |

The web and WebView builds use the online WebRTC path. The native **offline**
radios (Bluetooth, Wi-Fi Direct, Nearby/Multipeer) are the next milestone and
live on the Flutter/native path — see `docs/BUILD_PLAN.md`.

## License
MIT — see [LICENSE](LICENSE).

## Live preview

The web app in `web/` is genuinely static: `web/index.html` plus vendored
JS, with serverless pairing (the connection code is exchanged by QR code or
paste, per `web/index.html` and `docs/ABOUT.md`) — no app server is needed.
Local preview today, from the repo root:

```
cd web && python3 serve.py
```

GitHub Pages note: the Pages branch-folder setting only offers the repo
root or `/docs` — it cannot point at `web/`. So this PR adds no Pages
preview, and no preview URL is live from it. Post-merge option: manually
add a Pages Actions workflow deploying `web/` via the GitHub web UI
(workflow files cannot be pushed via the Muse GitHub App, so that step is
not in this PR), or serve `web/` from any static host.
