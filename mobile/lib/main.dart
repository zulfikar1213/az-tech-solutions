import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'login_screen.dart';
import 'owner_bookings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A.Z Tech Solutions',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: AuthService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.data == true) {
            return const OwnerBookingsScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}