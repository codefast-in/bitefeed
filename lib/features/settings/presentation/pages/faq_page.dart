import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'HELP & SUPPORT',
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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          FaqItem(
            question: 'How Do I Create A New Account?',
            answer:
                'This Web App Is Designed To Help Users Complete Tasks Smoothly By Guiding Them Through A Clear And Structured Journey.\nIt Improves User Experience, Reduces Confusion, And Makes Navigation Simple And Fast.',
            isExpanded: true,
          ),
          SizedBox(height: 16),
          FaqItem(question: 'How Do I Log In To My Account?'),
          SizedBox(height: 16),
          FaqItem(question: 'Should I Do If I Forget My Password?'),
          SizedBox(height: 16),
          FaqItem(question: 'Personal Data Safe On This Platform?'),
          SizedBox(height: 16),
          FaqItem(question: 'How Do I Navigate Through The App?'),
          SizedBox(height: 16),
          FaqItem(question: 'How Do I Update My Profile Details?'),
        ],
      ),
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String? answer;
  final bool isExpanded;

  const FaqItem({
    super.key,
    required this.question,
    this.answer,
    this.isExpanded = false,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.isExpanded,
          title: Text(
            widget.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
            color: Colors.black,
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                widget.answer ?? 'Answer not available.',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
