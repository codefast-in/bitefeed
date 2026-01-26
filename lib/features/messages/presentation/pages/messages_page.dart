import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final Set<int> _selectedIndices = {};

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: const Text(
          'MESSAGES',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/whiteSearchIcon.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildChatItem(
                      context,
                      index: 0,
                      name: 'Sarah Johnson',
                      message: 'Let\'s Check Out That New Sushi Place!',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=sarah',
                      isUnread: true,
                    ),
                    _buildChatItem(
                      context,
                      index: 1,
                      name: 'Foody Group',
                      message: 'Thanks For The Recommendation!',
                      time: '2 Min Ago',
                      isGroup: true,
                    ),
                    _buildChatItem(
                      context,
                      index: 2,
                      name: 'Emma Davis',
                      message: 'Have You Tried The Dessert Place?',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=emma',
                    ),
                    _buildChatItem(
                      context,
                      index: 3,
                      name: 'Sarah Johnson',
                      message: 'Let\'s Check Out That New Sushi Place!',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=sarah2',
                      isUnread: true,
                    ),
                    _buildChatItem(
                      context,
                      index: 4,
                      name: 'Mike Chen',
                      message: 'Thanks For The Recommendation!',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=mike',
                    ),
                    _buildChatItem(
                      context,
                      index: 5,
                      name: 'Emma Davis',
                      message: 'Have You Tried The Dessert Place?',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=emma2',
                    ),
                    _buildChatItem(
                      context,
                      index: 6,
                      name: 'Sarah Johnson',
                      message: 'Let\'s Check Out That New Sushi Place!',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=sarah3',
                      isUnread: true,
                    ),
                    _buildChatItem(
                      context,
                      index: 7,
                      name: 'Mike Chen',
                      message: 'Thanks For The Recommendation!',
                      time: '2 Min Ago',
                      avatarUrl: 'https://i.pravatar.cc/150?u=mike2',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80), // Space for bottom bar
            ],
          ),
          if (_selectedIndices.length > 1)
            Positioned(
              bottom: 100,
              right: 24,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Action for sending message to multiple
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required int index,
    required String name,
    required String message,
    required String time,
    String? avatarUrl,
    bool isUnread = false,
    bool isGroup = false,
  }) {
    bool isSelected = _selectedIndices.contains(index);

    return GestureDetector(
      onTap: () {
        if (_selectedIndices.isNotEmpty) {
          _toggleSelection(index);
        } else {
          Navigator.pushNamed(context, AppRoutes.chat, arguments: name);
        }
      },
      onLongPress: () => _toggleSelection(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primaryOrange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _toggleSelection(index),
              child: Image.asset(
                isSelected
                    ? 'assets/icons/checkBoxActiveIcon.png'
                    : 'assets/icons/checkBoxInactiveIcon.png',
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 12),
            if (isGroup)
              _buildGroupAvatar()
            else
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupAvatar() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[300],
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=1',
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[400],
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=2',
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[500],
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=3',
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey[600],
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=4',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
