import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

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
      _estimatedMinutes = _position * 3; // 3 mins per person
    });

    _startQueueSimulation();
  }

  //////////////////////////////////////////////////////////
  // SIMULATE LIVE QUEUE MOVEMENT
  //////////////////////////////////////////////////////////

  void _startQueueSimulation() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_position > 1) {
        setState(() {
          _position--;
          _estimatedMinutes = _position * 3;
        });
      } else {
        timer.cancel();
        _goToStatusScreen();
      }
    });
  }

  //////////////////////////////////////////////////////////
  // NAVIGATE WHEN IT'S USER'S TURN
  //////////////////////////////////////////////////////////

  void _goToStatusScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const StatusScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //////////////////////////////////////////////////////////
  // UI
  //////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Queue'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isInQueue ? _buildQueueStatus() : _buildJoinState(),
      ),
    );
  }

  //////////////////////////////////////////////////////////
  // JOIN STATE UI
  //////////////////////////////////////////////////////////

  Widget _buildJoinState() {
    return Center(
      child: ElevatedButton(
        onPressed: _joinQueue,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Join Queue',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////
  // QUEUE STATUS UI
  //////////////////////////////////////////////////////////

  Widget _buildQueueStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'You are in queue',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        _buildStatusCard(),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Position #$_position',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimated wait: $_estimatedMinutes mins',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////
// STATUS SCREEN (When It's User's Turn)
//////////////////////////////////////////////////////////

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                'It\'s Your Turn!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please proceed to the service desk.',
                style: TextStyle(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
