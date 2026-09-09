import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../core/signal.dart';

typedef DataHandler = void Function(String data);
typedef StateHandler = void Function(String state);

/// The swappable transport layer. This implementation is the WebRTC data channel
/// (the "online spine"). Other backends — LAN sockets + mDNS, Nearby/Multipeer,
/// BLE — can later implement the same connect / send / onData / onState surface.
class P2PTransport {
  RTCPeerConnection? _pc;
  RTCDataChannel? _dc;
  DataHandler? onData;
  StateHandler? onState;

  static const _config = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ]
  };

  Future<void> _init() async {
    _pc = await createPeerConnection(_config);
  }

  void _wire(RTCDataChannel dc) {
    _dc = dc;
    dc.onMessage = (msg) => onData?.call(msg.text);
    dc.onDataChannelState = (s) {
      if (s == RTCDataChannelState.RTCDataChannelOpen) onState?.call('open');
      if (s == RTCDataChannelState.RTCDataChannelClosed) onState?.call('closed');
    };
  }

  /// Initiator: create the invite code to show as a QR.
  Future<String> createInvite() async {
    await _init();
    final dc = await _pc!.createDataChannel('mu', RTCDataChannelInit()..ordered = true);
    _wire(dc);
    await _pc!.setLocalDescription(await _pc!.createOffer());
    await _awaitIce();
    return encodeDesc((await _pc!.getLocalDescription())!);
  }

  /// Responder: accept the invite and produce the reply code.
  Future<String> acceptInvite(String code) async {
    await _init();
    _pc!.onDataChannel = _wire;
    await _pc!.setRemoteDescription(decodeDesc(code));
    await _pc!.setLocalDescription(await _pc!.createAnswer());
    await _awaitIce();
    return encodeDesc((await _pc!.getLocalDescription())!);
  }

  /// Initiator: apply the responder's reply code to finish the handshake.
  Future<void> applyAnswer(String code) async {
    await _pc!.setRemoteDescription(decodeDesc(code));
  }

  Future<void> _awaitIce() async {
    final done = Completer<void>();
    _pc!.onIceGatheringState = (s) {
      if (s == RTCIceGatheringState.RTCIceGatheringStateComplete && !done.isCompleted) {
        done.complete();
      }
    };
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!done.isCompleted) done.complete();
    });
    await done.future;
  }

  void send(String data) => _dc?.send(RTCDataChannelMessage(data));

  Future<void> close() async {
    await _dc?.close();
    await _pc?.close();
  }
}
