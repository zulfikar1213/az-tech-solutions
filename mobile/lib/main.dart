import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(const AzTechApp());
}

class AzTechApp extends StatelessWidget {
  const AzTechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A.Z Tech Solutions',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}