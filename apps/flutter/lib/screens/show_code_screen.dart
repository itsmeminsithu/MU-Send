import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../transport/webrtc_transport.dart';
import 'scan_screen.dart';

class ShowCodeScreen extends StatelessWidget {
  final P2PTransport transport;
  final String code;
  final bool isInitiator;
  const ShowCodeScreen(
      {super.key, required this.transport, required this.code, required this.isInitiator});

  Future<void> _scanReply(BuildContext context) async {
    final reply = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScanScreen(title: 'Scan their reply')),
    );
    if (reply != null) await transport.applyAnswer(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isInitiator ? 'Your code' : 'Your reply')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(children: [
          Text(
            isInitiator
                ? 'Show this to the other phone. When they show a reply, tap "Scan their reply".'
                : 'Show this back to the first phone. You will connect once they scan it.',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD9E0DC)),
                borderRadius: BorderRadius.circular(16)),
            child: QrImageView(data: code, size: 240),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Clipboard.setData(ClipboardData(text: code)),
                icon: const Icon(Icons.copy),
                label: const Text('Copy code'),
              ),
            ),
            if (isInitiator) const SizedBox(width: 10),
            if (isInitiator)
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: kTeal),
                  onPressed: () => _scanReply(context),
                  child: const Text('Scan their reply'),
                ),
              ),
          ]),
          if (!isInitiator)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 10),
                Text('waiting to connect…', style: TextStyle(color: kAmber)),
              ]),
            ),
        ]),
      ),
    );
  }
}
