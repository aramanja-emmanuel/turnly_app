import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'home_screen.dart';
import 'queue_screen.dart';
import 'status_screen.dart';
import 'user_profile_screen.dart';
import 'details_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TurnlyApp(),
    ),
  );
}

class TurnlyApp extends StatelessWidget {
  const TurnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Turnly App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),          // 1. User opens app → Home Screen
        '/queue': (_) => const QueueScreen(),    // 3. User joins queue
        '/status': (_) => const StatusScreen(),  // 5. When next → Status Screen shown
        '/profile': (_) => const UserProfileScreen(), // 9. Profile reflects new visit
        '/details': (_) => const DetailsScreen(),     // Optional: Queue details
      },
    );
  }
}