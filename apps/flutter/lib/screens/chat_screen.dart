import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme.dart';
import '../transport/webrtc_transport.dart';

class _Msg {
  final bool mine;
  final String? text;
  final Uint8List? image;
  final String? fileName;
  _Msg({required this.mine, this.text, this.image, this.fileName});
}

class _Incoming {
  final String name;
  final String mime;
  final List<String> parts;
  _Incoming(this.name, this.mime, int total) : parts = List.filled(total, '');
}

class ChatScreen extends StatefulWidget {
  final P2PTransport transport;
  final String myName;
  const ChatScreen({super.key, required this.transport, required this.myName});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<_Msg> _messages = [];
  final Map<String, _Incoming> _incoming = {};
  String _peer = 'Friend';
  bool _connected = true;

  @override
  void initState() {
    super.initState();
    widget.transport.onData = _onData;
    widget.transport.onState = (s) {
      if (s == 'closed' && mounted) setState(() => _connected = false);
    };
    widget.transport.send(jsonEncode({'t': 'hello', 'name': widget.myName}));
  }

  void _add(_Msg m) {
    setState(() => _messages.add(m));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _onData(String data) {
    final m = jsonDecode(data) as Map<String, dynamic>;
    switch (m['t']) {
      case 'hello':
        setState(() => _peer = (m['name'] as String?) ?? 'Friend');
        break;
      case 'text':
        _add(_Msg(mine: false, text: m['body'] as String));
        break;
      case 'fstart':
        _incoming[m['id']] =
            _Incoming(m['name'] as String, m['mime'] as String, m['total'] as int);
        break;
      case 'fchunk':
        _incoming[m['id']]?.parts[m['seq'] as int] = m['d'] as String;
        break;
      case 'fend':
        final rec = _incoming.remove(m['id']);
        if (rec != null) {
          final bytes = base64Decode(rec.parts.join());
          _add(rec.mime.startsWith('image/')
              ? _Msg(mine: false, image: bytes)
              : _Msg(mine: false, fileName: rec.name));
        }
        break;
    }
  }

  void _sendText() {
    final body = _input.text.trim();
    if (body.isEmpty) return;
    widget.transport.send(jsonEncode({'t': 'text', 'body': body}));
    _add(_Msg(mine: true, text: body));
    _input.clear();
  }

  Future<void> _attach() async {
    final res = await FilePicker.platform.pickFiles(withData: true);
    if (res == null || res.files.single.bytes == null) return;
    final f = res.files.single;
    final bytes = f.bytes!;
    final b64 = base64Encode(bytes);
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final mime = _mimeFor(f.extension);
    const ch = 8000;
    final total = (b64.length / ch).ceil();
    widget.transport.send(jsonEncode(
        {'t': 'fstart', 'id': id, 'name': f.name, 'mime': mime, 'total': total}));
    for (var i = 0; i < total; i++) {
      final end = ((i + 1) * ch).clamp(0, b64.length);
      widget.transport.send(jsonEncode(
          {'t': 'fchunk', 'id': id, 'seq': i, 'd': b64.substring(i * ch, end)}));
    }
    widget.transport.send(jsonEncode({'t': 'fend', 'id': id}));
    _add(mime.startsWith('image/')
        ? _Msg(mine: true, image: bytes)
        : _Msg(mine: true, fileName: f.name));
  }

  String _mimeFor(String? ext) {
    switch ((ext ?? '').toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.circle, size: 12, color: _connected ? kTeal : Colors.grey),
        ),
        title: Text(_peer),
      ),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _bubble(_messages[i]),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              IconButton(onPressed: _attach, icon: const Icon(Icons.attach_file)),
              Expanded(
                child: TextField(
                  controller: _input,
                  onSubmitted: (_) => _sendText(),
                  decoration: const InputDecoration(
                      hintText: 'Message', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: kTeal),
                onPressed: _sendText,
                icon: const Icon(Icons.send),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _bubble(_Msg m) {
    final color = m.mine ? kTeal : const Color(0xFFEFF2F0);
    final fg = m.mine ? Colors.white : kInk;
    Widget content;
    if (m.image != null) {
      content = ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(m.image!, width: 220, fit: BoxFit.cover));
    } else if (m.fileName != null) {
      content = Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.insert_drive_file, color: fg),
        const SizedBox(width: 8),
        Flexible(child: Text(m.fileName!, style: TextStyle(color: fg))),
      ]);
    } else {
      content = Text(m.text ?? '', style: TextStyle(color: fg));
    }
    return Align(
      alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
        child: content,
      ),
    );
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    widget.transport.close();
    super.dispose();
  }
}
