import 'package:flutter/material.dart';
import 'package:mycall/features/landing/ui/landing_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My call",
      debugShowCheckedModeBanner: false,
      home: LandingUi(),
    );
  }
}
