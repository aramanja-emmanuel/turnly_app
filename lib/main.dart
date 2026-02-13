import 'package:flutter/material.dart';
import 'package:turnly_app/status_screen.dart';
import 'package:turnly_app/user_profile_screen.dart';

void main() {
  runApp(const TurnlyApp());
}

class TurnlyApp extends StatelessWidget {
  const TurnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turnly App',
      debugShowCheckedModeBanner: false,
      home: const UserProfileScreen(),
    );
  }
}
