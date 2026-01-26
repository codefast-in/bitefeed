import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'avatar': 'https://i.pravatar.cc/150?u=sarah',
        'name': 'Sarah Johnson',
        'action': 'in your contacts joined the bite feed',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=mike',
        'name': 'Mike Chen',
        'action': 'saved your Bite "Barbeque Nation"',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=emma',
        'name': 'Emma Davis',
        'action': 'posted a new Bite nearby 📍 Tap to explore',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=jhony',
        'name': 'Jhony',
        'action': 'New message from Taylor 💬 "We should try this cafe!"',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=sarah2',
        'name': 'Sarah Johnson',
        'action': 'liked your Bite at La Pinoz 🍕',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=mike2',
        'name': 'Mike Chen',
        'action': 'saved your Bite "Barbeque Nation"',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=emma2',
        'name': 'Emma Davis',
        'action': 'posted a new Bite nearby 📍 Tap to explore',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=jhony2',
        'name': 'Jhony',
        'action': 'New message from Taylor 💬 "We should try this cafe!"',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=sarah3',
        'name': 'Sarah Johnson',
        'action': 'liked your Bite at La Pinoz 🍕',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=mike3',
        'name': 'Mike Chen',
        'action': 'saved your Bite "Barbeque Nation"',
        'time': '2m Ago',
      },
      {
        'avatar': 'https://i.pravatar.cc/150?u=emma3',
        'name': 'Emma Davis',
        'action': 'posted a new Bite nearby 📍 Tap to explore',
        'time': '2m Ago',
      },
    ];

    return Scaffold(
      body: Column(
        children: [
          // Gradient Header
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'NOTIFICATIONS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Balance the back button
                  ],
                ),
              ),
            ),
          ),
          // Notifications List
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(
                    avatar: notification['avatar']!,
                    name: notification['name']!,
                    action: notification['action']!,
                    time: notification['time']!,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String avatar,
    required String name,
    required String action,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatar)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $action',
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
