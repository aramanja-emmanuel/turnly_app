import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'home_screen.dart';
import 'queue_screen.dart';
import 'status_screen.dart';
import 'user_profile_screen.dart';
import 'details_screen.dart';

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local notifications
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
final initSettings = InitializationSettings(android: androidSettings);

await localNotifications.initialize(
  settings: initSettings, // required named parameter
  onDidReceiveNotificationResponse: (NotificationResponse details) {
    navigatorKey.currentState?.pushNamed('/status');
    },
  );

  runApp(const TurnlyApp());
}

class TurnlyApp extends StatelessWidget {
  const TurnlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Turnly App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/queue': (_) => const QueueScreen(),
        '/status': (_) => const StatusScreen(),
        '/profile': (_) => const UserProfileScreen(),
        '/details': (_) => const DetailsScreen(),
      },
    );
  }
}