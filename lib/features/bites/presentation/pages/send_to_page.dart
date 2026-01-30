import 'package:bitefeed/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SendToPage extends StatefulWidget {
  const SendToPage({super.key});

  @override
  State<SendToPage> createState() => _SendToPageState();
}

class _SendToPageState extends State<SendToPage> {
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
          'SEND TO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/whiteBackIcon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 9,
              itemBuilder: (context, index) {
                return _buildContactItem(context, index);
              },
            ),
            if (_selectedIndices.length > 1)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildSendOptions(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendOptions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(28),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chat,
                  arguments: "Sarah Johnson",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'Send Separately',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chat,
                  arguments: "Foody Group",
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Send To New Group Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, int index) {
    bool isSelected = _selectedIndices.contains(index);
    final contacts = [
      {
        'name': 'Sarah Johnson',
        'message': 'Let\'s Check Out That New Sushi Place!',
        'time': '2 Min Ago',
        'hasUnread': true,
      },
      {
        'name': 'Mike Chen',
        'message': 'Thanks For The Recommendation!',
        'time': '2 Min Ago',
        'hasUnread': false,
      },
      {
        'name': 'Emma Davis',
        'message': 'Have You Tried The Dessert Place?',
        'time': '2 Min Ago',
        'hasUnread': false,
      },
    ];

    final contact = contacts[index % contacts.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _toggleSelection(index),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$index'),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                contact['name'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              contact['time'] as String,
              style: TextStyle(fontSize: 11, color: AppColors.textGrey),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            contact['message'] as String,
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Image.asset(
          isSelected
              ? 'assets/icons/checkBoxActiveIcon.png'
              : 'assets/icons/checkBoxInactiveIcon.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
