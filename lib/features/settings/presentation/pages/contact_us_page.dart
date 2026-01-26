import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'CONTACT US',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildContactCard(
              title: 'Email',
              content: 'info@gmail.com',
              iconPath: 'assets/icons/contactUsMailIcon.png',
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              title: 'Call',
              content: '987-654-3210',
              iconPath: 'assets/icons/contactUsCallIcon.png',
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              title: 'Location',
              content:
                  '1258 evergreen drive,\nspringfield, illinois 62704,\nusa',
              iconPath: 'assets/icons/contactUsLocationIcon.png',
              isMultiLine: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String content,
    required String iconPath,
    bool isMultiLine = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: isMultiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color: const Color(0xFFE8F1FC), // Light blue background for icon
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
