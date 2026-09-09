import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme.dart';

class ScanScreen extends StatefulWidget {
  final String title;
  const ScanScreen({super.key, required this.title});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _paste = TextEditingController();
  bool _handled = false;

  void _done(String code) {
    if (_handled) return;
    _handled = true;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                onDetect: (capture) {
                  final raw = capture.barcodes.isNotEmpty
                      ? capture.barcodes.first.rawValue
                      : null;
                  if (raw != null) _done(raw);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Point at the other phone\'s QR code, or paste it below.',
              style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          TextField(
            controller: _paste,
            maxLines: 3,
            decoration: const InputDecoration(
                hintText: 'Paste the code', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kTeal),
              onPressed: () {
                final v = _paste.text.trim();
                if (v.isNotEmpty) _done(v);
              },
              child: const Text('Use pasted code'),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _paste.dispose();
    super.dispose();
  }
}
