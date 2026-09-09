import 'package:flutter/material.dart';

const kTeal = Color(0xFF0F9E74);
const kViolet = Color(0xFF5B4FC4);
const kAmber = Color(0xFFC07D18);
const kInk = Color(0xFF16211E);

ThemeData muSendTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kTeal, primary: kTeal),
    scaffoldBackgroundColor: Colors.white,
  );
}
