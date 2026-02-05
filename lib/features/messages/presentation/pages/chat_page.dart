import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/plan_visit_bottom_sheet.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'received',
      'content': 'Hey! Did You See My Latest Post?',
      'time': '10:30 AM',
    },
    {
      'type': 'sent',
      'content': 'Yes! That Pasta Looks Amazing',
      'time': '10:30 AM',
      'isRead': true,
    },
    {
      'type': 'received',
      'content': 'Right?! You Have To Try It',
      'time': '10:30 AM',
    },
    {
      'type': 'received_image',
      'imageUrl': 'assets/images/dish1.png',
      'restaurantName': 'The Golden Fork',
      'rating': 5,
      'time': '10:30 AM',
    },
    {
      'type': 'received',
      'content': 'Want To Go Together This Weekend?',
      'time': '10:30 AM',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'type': 'sent',
          'content': _messageController.text,
          'time': '10:30 AM',
          'isRead': false,
        });
        _messageController.clear();
      });
    }
  }

  void _showMediaSelectionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) => _buildMediaSelectionSheet(),
    );
  }

  Widget _buildMediaSelectionSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: SafeArea(
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select File',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildMediaOption(
              'assets/icons/galleryIcon.png',
              'Gallery',
              Colors.lightBlue.shade100,
              () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
            _buildMediaOption(
              'assets/icons/cameraIcon.png',
              'Camera',
              Colors.red.shade100,
              () => Navigator.pop(context),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaOption(
    String iconPath,
    String title,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(iconPath, width: 24, height: 24),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showPlanVisitSheet(String restaurantName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlanVisitBottomSheet(
        restaurantName: restaurantName,
        onSend: (date, time) {
          setState(() {
            _messages.add({
              'type': 'sent_plan',
              'restaurantName': restaurantName,
              'date': '${date.day} December', // Formatting simplified for demo
              'time': '10:30 PM', // Hardcoded as per design for demo
              'timestamp': '10:30 AM',
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name =
        ModalRoute.of(context)?.settings.arguments as String? ??
        'Sarah Johnson';
    bool isGroup = name == 'Foody Group';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        animateColor: false,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/whiteBackIcon.png',
            width: 20,
            height: 20,
            color: AppColors.primaryOrange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            if (isGroup)
              _buildSmallGroupAvatar()
            else
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=sarah',
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isGroup)
              Image.asset(
                'assets/icons/editPenIcon.png',
                width: 18,
                height: 18,
                // color: AppColors.primaryOrange,
              ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Image.asset(
              'assets/icons/otherUserDetailsOptionsIcon.png',
              width: 24,
              height: 24,
              // color: Colors.grey,
            ),
            offset: const Offset(0, 45),
            constraints: const BoxConstraints(minWidth: 150, maxWidth: 180),
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'Block') {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('User Blocked')));
              } else if (value == 'View Member') {
                Navigator.pushNamed(context, AppRoutes.groupMembers);
              } else if (value == 'Add Member') {
                Navigator.pushNamed(context, AppRoutes.addMembers);
              } else if (value == 'Leave Group') {
                Navigator.pushNamed(context, AppRoutes.leaveGroup);
              }
            },
            itemBuilder: (context) => isGroup
                ? [
                    const PopupMenuItem(
                      value: 'Leave Group',
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Leave Group',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Add Member',
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Add Member', style: TextStyle(fontSize: 14)),
                    ),
                    const PopupMenuItem(
                      value: 'View Member',
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'View Member',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ]
                : [
                    const PopupMenuItem(
                      value: 'Block',
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Block User', style: TextStyle(fontSize: 14)),
                    ),
                  ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + 1, // +1 for date header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Today',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  );
                }
                final message = _messages[index - 1];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSmallGroupAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: ClipOval(
        child: Image.asset(
          "assets/icons/groupChatIcon.png",
          width: 24,
          height: 24,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    if (message['type'] == 'received') {
      return _buildReceivedMessage(message['content'], message['time']);
    } else if (message['type'] == 'sent') {
      return _buildSentMessage(
        message['content'],
        message['time'],
        message['isRead'],
      );
    } else if (message['type'] == 'received_image') {
      return _buildImageMessage(message);
    } else if (message['type'] == 'sent_plan') {
      return _buildPlanMessage(message);
    }
    return const SizedBox();
  }

  Widget _buildReceivedMessage(String content, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(content, style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage(String content, String time, bool isRead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Text(
                content,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            if (isRead)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.remove_red_eye,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildImageMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 250,
          margin: const EdgeInsets.only(top: 8, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.asset(
                  message['imageUrl'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['restaurantName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () =>
                            _showPlanVisitSheet(message['restaurantName']),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text(
                          'Plan a Visit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            message['time'],
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanMessage(Map<String, dynamic> message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: AppColors.primaryOrange,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Let\'s Meet at',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${message['date']} ${message['time']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.remove_red_eye,
                color: AppColors.primaryRed,
                size: 20,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(
            message['timestamp'],
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showMediaSelectionSheet,
                      child: Image.asset(
                        'assets/icons/messageInputLinkIcon.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Your message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Image.asset(
                'assets/icons/messagerInputSendIcon.png',
                width: 28,
                height: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
