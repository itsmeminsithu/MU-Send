# MU Send — build plan

The architecture behind the apps, and the roadmap for the offline transports.

## The one constraint
Because web is a target, the only transports that work on **all** platforms are
WebRTC (P2P over the internet) and a WebSocket to a server. A browser can't do
WiFi Direct, Nearby, Multipeer, raw sockets, or Bluetooth. So MU Send is two
subsystems: an **online** one that works everywhere, and an **offline** one that
is mobile-only — and where Android and iOS can't reach each other directly.

| Transport | Android | iOS | Web |
|-----------|:---:|:---:|:---:|
| WebRTC data channel (needs internet) | yes | yes | yes |
| WebSocket to server | yes | yes | yes |
| LAN sockets + mDNS (same Wi-Fi) | yes | yes | no |
| Nearby Connections (offline) | yes | no | no |
| Multipeer (offline) | no | yes | no |
| WiFi Direct (offline) | yes | no | no |
| BLE (offline, slow) | yes | yes | partial |

Nearby (Android) and Multipeer (iOS) don't interoperate — Android-to-iOS offline
falls back to BLE or a shared hotspot.

## Architecture
One **transport abstraction layer** with a single `connect / send / onData /
onState` surface, and swappable backends. Above it, a message envelope handles
chunking, ids, and acks so text, photos, and files travel the same way. In this
repo the Flutter code shows the shape: `lib/transport/webrtc_transport.dart`
implements that surface with a WebRTC data channel.

## Pairing
No account. One phone shows a QR (connection info + public key), the other scans
it and shows a reply back. Scanning in person opens the link and bootstraps
end-to-end encryption at once — which is safer than server-based key exchange.

## Roadmap
1. **Online spine** — WebRTC + pairing + chat (done: web, Android, iOS shells).
2. **Same-Wi-Fi offline** — LAN sockets + mDNS, plus the offline outbox.
3. **Native offline** — Nearby (Android) and Multipeer (iOS), BLE as the bridge.
4. **Hardening** — presence privacy, abuse controls, Burmese Unicode/Zawgyi,
   voice notes.
