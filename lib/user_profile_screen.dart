import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =====================================================
/// USER MODEL
/// =====================================================
class UserModel {
  final String fullName;
  final String email;
  final String memberSince;
  final String profileImageUrl;

  UserModel({
    required this.fullName,
    required this.email,
    required this.memberSince,
    required this.profileImageUrl,
  });
}

/// =====================================================
/// USER PROVIDER (Simulated Auth User)
/// =====================================================
final userProvider = Provider<UserModel>((ref) {
  return UserModel(
    fullName: "Aramanja Emmanuel",
    email: "zoeinemmy@gmail.com",
    memberSince: "2023",
    profileImageUrl: "https://i.pravatar.cc/300",
  );
});

/// =====================================================
/// USER PROFILE SCREEN
/// =====================================================
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Colors.black54),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// PROFILE IMAGE WITH LOADING + FALLBACK
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Image.network(
                  user.profileImageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              user.email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 4),

            Text(
              "Member since ${user.memberSince}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// ================= STATS ROW =================
            Row(
              children: [
                _statCard("24", "TOTAL VISITS"),
                const SizedBox(width: 12),
                _statCard("1", "ACTIVE"),
                const SizedBox(width: 12),
                _statCard("4.9", "RATING"),
              ],
            ),

            const SizedBox(height: 25),

            /// ================= QUEUE HISTORY =================
            _sectionTitle("Queue History"),
            const SizedBox(height: 10),

            _historyTile(
              icon: Icons.account_balance,
              title: "City Hall Services",
              subtitle: "Completed • Wait time 15m",
              date: "Oct 24",
            ),

            _historyTile(
              icon: Icons.local_hospital,
              title: "Ologuneru Health Center, IBADAN",
              subtitle: "Completed • Wait time 45m",
              date: "Oct 18",
            ),

            const SizedBox(height: 25),

            /// ================= ACCOUNT SETTINGS =================
            _sectionTitle("Account Settings"),
            const SizedBox(height: 10),

            _settingsTile("Notification Preferences"),
            _settingsTile("Linked Accounts"),
            _settingsTile("Privacy & Data"),

            const SizedBox(height: 25),

            /// ================= SIGN OUT =================
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Signed out successfully")),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ================= HELPER WIDGETS =================

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _historyTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}