import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// =============================
/// QUEUE STATUS ENUM
/// =============================
enum QueueStatus { waiting, next, arrived, delayed }

/// =============================
/// QUEUE MODEL
/// =============================
class QueueData {
  final String ticketNumber;
  final String branch;
  final int counter;
  final QueueStatus status;

  QueueData({
    required this.ticketNumber,
    required this.branch,
    required this.counter,
    required this.status,
  });

  QueueData copyWith({
    String? ticketNumber,
    String? branch,
    int? counter,
    QueueStatus? status,
  }) {
    return QueueData(
      ticketNumber: ticketNumber ?? this.ticketNumber,
      branch: branch ?? this.branch,
      counter: counter ?? this.counter,
      status: status ?? this.status,
    );
  }
}

/// =============================
/// STATE NOTIFIER (Simulated Backend)
/// =============================
class QueueNotifier extends StateNotifier<QueueData> {
  QueueNotifier()
      : super(
          QueueData(
            ticketNumber: "#A-248",
            branch: "Downtown Branch",
            counter: 3,
            status: QueueStatus.next, // simulate “Next”
          ),
        );

  void confirmArrival() {
    state = state.copyWith(status: QueueStatus.arrived);
  }

  void requestDelay() {
    state = state.copyWith(
      status: QueueStatus.delayed,
      counter: state.counter + 1,
    );
  }

  void markAsNext(int counterNumber) {
    state = state.copyWith(
      status: QueueStatus.next,
      counter: counterNumber,
    );
  }
}

final queueProvider =
    StateNotifierProvider<QueueNotifier, QueueData>((ref) {
  return QueueNotifier();
});

/// =============================
/// STATUS SCREEN
/// =============================
class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider);
    final notifier = ref.read(queueProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Queue Status",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              /// ==========================
              /// GREEN NOTIFICATION BADGE
              /// ==========================
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E).withOpacity(.15),
                ),
                child: Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF22C55E),
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ==========================
              /// HEADLINE
              /// ==========================
              Text(
                queue.status == QueueStatus.next
                    ? "You're Next!"
                    : queue.status == QueueStatus.arrived
                        ? "You're Checked In"
                        : queue.status == QueueStatus.delayed
                            ? "Delay Requested"
                            : "Waiting...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 6),

              /// ==========================
              /// SUBHEADING
              /// ==========================
              Text(
                "Head to Counter ${queue.counter}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),

              const SizedBox(height: 18),

              /// ==========================
              /// DESCRIPTION
              /// ==========================
              const Text(
                "Your turn has arrived. Please\nmake your way to the\ndesignated service area now.\nOur representative is ready to\nassist you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 30),

              /// ==========================
              /// TICKET INFO CARD
              /// ==========================
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow("Ticket Number", queue.ticketNumber),
                    const SizedBox(height: 18),
                    _infoRow("Location", queue.branch),
                  ],
                ),
              ),

              const Spacer(),

              /// ==========================
              /// PRIMARY BUTTON
              /// ==========================
              if (queue.status == QueueStatus.next)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      notifier.confirmArrival();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Arrival confirmed."),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline,
                        size: 20, color: Colors.white),
                    label: const Text(
                      "I'm here",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              /// ==========================
              /// SECONDARY ACTION
              /// ==========================
              if (queue.status == QueueStatus.next)
                TextButton(
                  onPressed: () {
                    notifier.requestDelay();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Delay request sent."),
                      ),
                    );
                  },
                  child: const Text(
                    "Need more time?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
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
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}