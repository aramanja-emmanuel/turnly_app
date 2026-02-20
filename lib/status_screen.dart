import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// =========================
/// QUEUE STATUS ENUM
/// =========================
enum QueueStatus {
  waiting,
  next,
  arrived,
  delayed,
}

/// =========================
/// QUEUE MODEL
/// =========================
class QueueData {
  final String ticketNumber;
  final String branchLocation;
  final int counterNumber;
  final QueueStatus status;

  QueueData({
    required this.ticketNumber,
    required this.branchLocation,
    required this.counterNumber,
    required this.status,
  });

  QueueData copyWith({
    String? ticketNumber,
    String? branchLocation,
    int? counterNumber,
    QueueStatus? status,
  }) {
    return QueueData(
      ticketNumber: ticketNumber ?? this.ticketNumber,
      branchLocation: branchLocation ?? this.branchLocation,
      counterNumber: counterNumber ?? this.counterNumber,
      status: status ?? this.status,
    );
  }
}

/// =========================
/// QUEUE PROVIDER
/// =========================
final queueProvider =
    StateNotifierProvider<QueueNotifier, QueueData>((ref) {
  return QueueNotifier();
});

class QueueNotifier extends StateNotifier<QueueData> {
  QueueNotifier()
      : super(
          QueueData(
            ticketNumber: "#A-248",
            branchLocation: "Downtown Branch",
            counterNumber: 3,
            status: QueueStatus.waiting,
          ),
        );

  /// Simulate queue progressing to "Next"
  void markAsNext() {
    state = state.copyWith(status: QueueStatus.next);
  }

  /// User confirms arrival
  void confirmArrival() {
    state = state.copyWith(status: QueueStatus.arrived);
  }

  /// User requests delay
  void requestDelay() {
    state = state.copyWith(
      status: QueueStatus.delayed,
      counterNumber: state.counterNumber + 1, // simulate reassignment
    );
  }
}

/// =========================
/// STATUS SCREEN
/// =========================
class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(queueProvider);

    /// Auto-redirect when status becomes NEXT
    if (queue.status == QueueStatus.next) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("It's your turn! Please proceed."),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
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
            _buildBadge(queue.status),

            const SizedBox(height: 28),

            /// Headline
            Text(
              queue.status == QueueStatus.next
                  ? "You're Next!"
                  : queue.status == QueueStatus.arrived
                      ? "Checked In"
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

            /// Subheading (Dynamic Counter)
            Text(
              "Head to Counter ${queue.counterNumber}",
              style: const TextStyle(
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                  _infoRow('Ticket Number', queue.ticketNumber),
                  const SizedBox(height: 14),
                  _infoRow('Location', queue.branchLocation),
                ],
              ),
            ),

            const Spacer(),

            /// PRIMARY CTA
            if (queue.status == QueueStatus.next)
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(queueProvider.notifier).confirmArrival();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "I'm here",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 18),

            /// SECONDARY ACTION
            if (queue.status == QueueStatus.next)
              TextButton(
                onPressed: () {
                  ref.read(queueProvider.notifier).requestDelay();
                },
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

  Widget _buildBadge(QueueStatus status) {
    Color innerColor;
    IconData icon;

    switch (status) {
      case QueueStatus.next:
        innerColor = const Color(0xFF22C55E);
        icon = Icons.notifications_none_rounded;
        break;
      case QueueStatus.arrived:
        innerColor = Colors.blue;
        icon = Icons.check_circle_outline;
        break;
      case QueueStatus.delayed:
        innerColor = Colors.orange;
        icon = Icons.schedule;
        break;
      default:
        innerColor = Colors.grey;
        icon = Icons.hourglass_empty;
    }

    return Container(
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerColor,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
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