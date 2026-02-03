import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({super.key});

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final List<Map<String, dynamic>> _members = [
    {
      'name': 'Sarah Johnson',
      'image': 'https://i.pravatar.cc/150?u=sarah',
      'selected': true,
    },
    {
      'name': 'Mike Chen',
      'image': 'https://i.pravatar.cc/150?u=mike',
      'selected': false,
    },
    {
      'name': 'Emma Davis',
      'image': 'https://i.pravatar.cc/150?u=emma',
      'selected': true,
    },
    {
      'name': 'Sarah Johnson',
      'image': 'https://i.pravatar.cc/150?u=sarah2',
      'selected': false,
    },
    {
      'name': 'Sarah Johnson',
      'image': 'https://i.pravatar.cc/150?u=sarah3',
      'selected': true,
    },
    {
      'name': 'Mike Chen',
      'image': 'https://i.pravatar.cc/150?u=mike2',
      'selected': false,
    },
    {
      'name': 'Emma Davis',
      'image': 'https://i.pravatar.cc/150?u=emma2',
      'selected': true,
    },
    {
      'name': 'Sarah Johnson',
      'image': 'https://i.pravatar.cc/150?u=sarah4',
      'selected': false,
    },
    {
      'name': 'Mike Chen',
      'image': 'https://i.pravatar.cc/150?u=mike3',
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ADD MEMBERS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        top:false,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(member['image']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            member['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: member['selected'],
                          onChanged: (value) {
                            setState(() {
                              member['selected'] = value;
                            });
                          },
                          activeColor: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
