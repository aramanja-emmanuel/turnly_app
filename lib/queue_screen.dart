import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart'; // for localNotifications and navigatorKey
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  bool _isInQueue = false;
  int _position = 0;
  int _estimatedMinutes = 0;
  Timer? _timer;

  void _joinQueue() {
    final random = Random();
    final startPosition = random.nextInt(5) + 3; // 3–7 people ahead

    setState(() {
      _isInQueue = true;
      _position = startPosition;
      _estimatedMinutes = _position * 3;
    });

    _startQueueSimulation();
  }

  void _startQueueSimulation() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_position > 1) {
        int oldPosition = _position;

        setState(() {
          _position--;
          _estimatedMinutes = _position * 3;
        });

        // Notify if position changes significantly
        if ((oldPosition - _position) >= 2) {
          _showNotification(
            title: "Queue Update",
            body: "Your position moved significantly. Now #$_position",
          );
        }

        // Notify if user is next
        if (_position == 1) {
          _showNotification(
            title: "You're Next!",
            body: "Please head to your service counter.",
          );
        }
      } else {
        timer.cancel();
        Navigator.pushReplacementNamed(context, '/status');
      }
    });
  }

  void _requestDelay() {
    setState(() {
      _position += 1;
      _estimatedMinutes += 3;
    });

    _showNotification(
      title: "Delay Approved",
      body: "Your delay is approved. New position #$_position",
    );
  }

  void _showNotification({required String title, required String body}) {
    final androidDetails = AndroidNotificationDetails(
      'queue_channel',
      'Queue Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    localNotifications.show(
      id: 0, // required named parameter
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isInQueue ? _buildQueueStatus() : _buildJoinState(),
      ),
    );
  }

  Widget _buildJoinState() {
    return Center(
      child: ElevatedButton(
        onPressed: _joinQueue,
        child: const Text("Join Queue"),
      ),
    );
  }

  Widget _buildQueueStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Position: $_position",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text("Estimated wait: $_estimatedMinutes mins"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _requestDelay,
          child: const Text("Request Delay"),
        ),
      ],
    );
  }
}