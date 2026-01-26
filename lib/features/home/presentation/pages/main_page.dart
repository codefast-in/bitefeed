import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'feed_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../bites/presentation/pages/bites_page.dart';
import '../../../bites/presentation/pages/create_bite_sheet.dart';
import '../../../messages/presentation/pages/messages_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FeedPage(),
    const BitesPage(),
    const Scaffold(body: Center(child: Text('Camera'))),
    const MessagesPage(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildNavItem(
              0,
              'assets/icons/tabFeedInactiveIcon.png',
              'assets/icons/tabFeedActiveIcon.png',
              'Feed',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              1,
              'assets/icons/tabBitesInactiveIcon.png',
              'assets/icons/tabBitesActiveIcon.png',
              'Bites',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => showCreateBiteSheet(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,

                      border: Border.all(
                        color: Colors.white,
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/tabCameraIcon.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildNavItem(
              3,
              'assets/icons/tabMessageInactiveIocn.png',
              'assets/icons/tabMessageActiveIcon.png',
              'Message',
            ),
          ),
          Expanded(
            child: _buildNavItem(
              4,
              'assets/icons/tabSearchInactiveIcon.png',
              'assets/icons/tabSearchActiveIcon.png',
              'Search',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String inactiveIcon,
    String activeIcon,
    String label,
  ) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            isSelected ? activeIcon : inactiveIcon,
            width: 24,
            height: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryOrange : AppColors.textGrey,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
