import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/connect_screen.dart';

void main() => runApp(const MuSendApp());

class MuSendApp extends StatelessWidget {
  const MuSendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MU Send',
      debugShowCheckedModeBanner: false,
      theme: muSendTheme(),
      home: const ConnectScreen(),
    );
  }
}
