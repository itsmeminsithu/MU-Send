import 'package:flutter/material.dart';
import '../theme.dart';
import '../transport/webrtc_transport.dart';
import 'show_code_screen.dart';
import 'scan_screen.dart';
import 'chat_screen.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});
  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final _name = TextEditingController(text: 'You');

  void _wireOpen(P2PTransport t) {
    t.onState = (s) {
      if (s == 'open' && mounted) {
        Navigator.of(context).popUntil((r) => r.isFirst);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreen(transport: t, myName: _name.text.trim()),
        ));
      }
    };
  }

  Future<void> _send() async {
    final t = P2PTransport();
    _wireOpen(t);
    final code = await t.createInvite();
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ShowCodeScreen(transport: t, code: code, isInitiator: true),
    ));
  }

  Future<void> _receive() async {
    final code = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScanScreen(title: 'Scan their code')),
    );
    if (code == null || !mounted) return;
    final t = P2PTransport();
    _wireOpen(t);
    final reply = await t.acceptInvite(code);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ShowCodeScreen(transport: t, code: reply, isInitiator: false),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.radar, size: 72, color: kTeal),
              const SizedBox(height: 12),
              const Text('MU Send',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: kInk)),
              const SizedBox(height: 6),
              const Text('Chat phone to phone. No account, no server.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 26),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                    labelText: 'Your name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: kTeal,
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: _send,
                    child: const Text('Send'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: kViolet,
                        side: const BorderSide(color: kViolet),
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    onPressed: _receive,
                    child: const Text('Receive'),
                  ),
                ),
              ]),
              const SizedBox(height: 18),
              const Text(
                'One phone taps Send and shows the code. The other taps Receive, scans it, then shows the reply back.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }
}
