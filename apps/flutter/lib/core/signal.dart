import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Pack an SDP description into a compact code for the QR / paste flow,
/// and unpack it again on the other phone.
String encodeDesc(RTCSessionDescription d) =>
    'MU1${base64Url.encode(utf8.encode(jsonEncode({'t': d.type, 's': d.sdp})))}';

RTCSessionDescription decodeDesc(String code) {
  var c = code.trim();
  if (c.startsWith('MU1')) c = c.substring(3);
  final o = jsonDecode(utf8.decode(base64Url.decode(c))) as Map<String, dynamic>;
  return RTCSessionDescription(o['s'] as String, o['t'] as String);
}
