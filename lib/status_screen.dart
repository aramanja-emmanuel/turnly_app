import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Queue Status',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 36),

            /// Notification Badge
            Container(
              height: 96,
              width: 96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE9F9EF),
              ),
              child: Center(
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF22C55E),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            /// Title
            const Text(
              "You're Next!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 6),

            /// Highlight Text
            const Text(
              "Head to Counter 3",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2563EB),
              ),
            ),

            const SizedBox(height: 14),

            /// Description
            const Text(
              "Your turn has arrived. Please\nmake your way to the designated\nservice area now.\nOur representative is ready to\nassist you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.55,
                color: Color(0xFF6B7280),
              ),
            ),

            const SizedBox(height: 28),

            /// Ticket Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _infoRow('Ticket Number', '#A-248'),
                  const SizedBox(height: 14),
                  _infoRow('Location', 'Downtown Branch'),
                ],
              ),
            ),

            const Spacer(),

            /// Primary CTA
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 20, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "I'm here",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// Secondary Action
            TextButton(
              onPressed: () {},
              child: const Text(
                'Need more time?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),

            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}
