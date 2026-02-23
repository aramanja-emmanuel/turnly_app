import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turnly'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              /// Responsive Banner Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/turnlyimage1.PNG',
                  width: screenWidth,
                  height: screenWidth * 0.6,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              /// Headline
              const Text(
                'Welcome to Turnly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              /// Description
              const Text(
                'Virtual queue management and instant notifications for a seamless service experience.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              /// Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to QueueScreen
                    Navigator.pushNamed(context, '/queue');
                  },
                  child: 
                  const Text('Get Started', 
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600),
                      ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}