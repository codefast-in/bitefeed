import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationEnabled = false;
  bool _isLocationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/whiteBackIcon.png',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'SETTINGS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Builder(
                        builder: (context) => IconButton(
                          icon: Image.asset(
                            'assets/icons/drawerMenuIcon.png',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/userProfilePhoto.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Jack Smiths',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      '26',
                      'My Bites',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.myPosts),
                    ),
                    Container(height: 40, width: 1, color: Colors.white24),
                    _buildStatItem(
                      '85k',
                      'Followers',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.followers),
                    ),
                    Container(height: 40, width: 1, color: Colors.white24),
                    _buildStatItem(
                      '150',
                      'Following',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.following),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/dish${index + 1}.png',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 24,
              right: 24,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BITEFEED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'SAVE & SHARE YOUR TASTY ADVENTURES',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/searchCrossIcon.png',
                      color: AppColors.primaryRed,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(
                  'assets/icons/editProfileIcon.png',
                  'Edit Profile',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.editProfile),
                ),
                _buildDrawerItem(
                  'assets/icons/notificationToggleIcon.png',
                  'Notification',
                  hasSwitch: true,
                  switchValue: _isNotificationEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _isNotificationEnabled = value;
                    });
                  },
                ),
                _buildDrawerItem(
                  'assets/icons/locationToggleIcon.png',
                  'Location',
                  hasSwitch: true,
                  switchValue: _isLocationEnabled,
                  onSwitchChanged: (value) {
                    setState(() {
                      _isLocationEnabled = value;
                    });
                  },
                ),
                _buildDrawerItem(
                  'assets/icons/helpAndSupportIcon.png',
                  'Help & Support',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.helpSupport),
                ),
                _buildDrawerItem(
                  'assets/icons/blockListIcon.png',
                  'Block List',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.blockList),
                ),
                _buildDrawerItem(
                  'assets/icons/logoutIcon.png',
                  'Logout',
                  onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    String iconPath,
    String title, {
    bool hasSwitch = false,
    bool? switchValue,
    ValueChanged<bool>? onSwitchChanged,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: hasSwitch
          ? null
          : onTap, // If switch, tap handles by switch usually, or we can allow tap row
      child: Container(
        color: (switchValue == true && hasSwitch)
            ? AppColors.primaryOrange.withOpacity(0.1)
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasSwitch)
              Switch(
                value: switchValue ?? false,
                onChanged: onSwitchChanged,
                activeColor: AppColors.primaryOrange,
              ),
          ],
        ),
      ),
    );
  }
}
