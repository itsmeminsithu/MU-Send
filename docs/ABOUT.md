# About MU Send

MU Send is a phone-to-phone messenger with **no account and no server**. Two
people pair by scanning each other's QR code, then chat and send photos and
files directly, device to device.

## Why it exists
Most people already have WhatsApp, Messenger, or Viber, and nobody switches chat
apps without a reason. MU Send's reason is simple: it works in the moments those
apps fail — no signal, a data blackout, a crowded venue, or two phones that just
want to swap files with nothing in between. That's a real gap for travelling and
low-connectivity users, especially across Myanmar and the region.

## How it works, briefly
- **Pairing** — one phone shows a QR code, the other scans it and shows a reply
  code back. That single exchange both opens the connection and (on the native
  builds) sets up encryption in person.
- **Transport** — the connection is a direct WebRTC data channel between the two
  phones, encrypted in transit by WebRTC's built-in DTLS. No message passes
  through a server.
- **Identity** — there is no account. A device is just a keypair; nothing is
  stored in the cloud.

## Builds in this repo
| Build | Stack | Status |
|-------|-------|--------|
| Web | HTML + JS | Complete, runs today |
| Android | Kotlin + WebView | Complete, buildable |
| iOS | Swift + WKWebView | Source + project config |
| Flutter | Dart (Android + iOS) | Source scaffold |

## Roadmap
The web/WebView builds use the online (WebRTC) path. The next milestone is the
native offline transports — Bluetooth, WiFi Direct, and Nearby/Multipeer — which
only the Flutter/native path can reach. See `docs/BUILD_PLAN.md`.
