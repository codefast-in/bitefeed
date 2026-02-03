import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../models/bite_model.dart';
import '../widgets/bite_list_item.dart';
import '../widgets/bite_card_item.dart';

enum SortOption { recent, highestRated, aToZ }

enum ViewMode { list, card }

class BitesPage extends StatefulWidget {
  const BitesPage({super.key});

  @override
  State<BitesPage> createState() => _BitesPageState();
}

class _BitesPageState extends State<BitesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFilterMenu = false;
  SortOption _selectedSort = SortOption.recent;
  ViewMode _selectedView = ViewMode.list;

  // Sample data
  List<Bite> _myBites = [];
  List<Bite> _savedBites = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeSampleData();
  }

  void _initializeSampleData() {
    _myBites = [
      Bite(
        id: '1',
        restaurantName: 'The Golden Fork',
        imageUrl: 'assets/images/dish1.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
      Bite(
        id: '2',
        restaurantName: 'Morning Brew Café',
        imageUrl: 'assets/images/dish2.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
      Bite(
        id: '3',
        restaurantName: 'Sweet Dreams Bakery',
        imageUrl: 'assets/images/dish1.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
      Bite(
        id: '4',
        restaurantName: 'Sakura Sushi Bar',
        imageUrl: 'assets/images/dish2.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
      Bite(
        id: '5',
        restaurantName: 'Green Bowl Kitchen',
        imageUrl: 'assets/images/dish1.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
      Bite(
        id: '6',
        restaurantName: 'Bella\'s Pizzeria',
        imageUrl: 'assets/images/dish2.png',
        rating: 5,
        date: DateTime(2025, 11, 28),
      ),
    ];

    _savedBites = List.from(_myBites);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Bite> _getSortedBites(List<Bite> bites) {
    List<Bite> sorted = List.from(bites);

    switch (_selectedSort) {
      case SortOption.recent:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.highestRated:
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.aToZ:
        sorted.sort((a, b) => a.restaurantName.compareTo(b.restaurantName));
        break;
    }

    return sorted;
  }

  void _deleteBite(String id) {
    setState(() {
      _myBites.removeWhere((bite) => bite.id == id);
      _savedBites.removeWhere((bite) => bite.id == id);
    });
  }

  void _navigateToSendTo() {
    Navigator.pushNamed(context, AppRoutes.sendTo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5ED),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        title: const Text(
          'BITES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Image.asset(
              'assets/icons/filterIcon.png',
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            offset: const Offset(0, 45),
            constraints: const BoxConstraints(minWidth: 150, maxWidth: 180),
            onSelected: (value) {
              // Handle selection
              if (value == 'Recent' ||
                  value == 'Highest Rated' ||
                  value == 'A-Z') {
                SortOption newSort;
                if (value == 'Recent')
                  newSort = SortOption.recent;
                else if (value == 'Highest Rated')
                  newSort = SortOption.highestRated;
                else
                  newSort = SortOption.aToZ;

                setState(() {
                  _selectedSort = newSort;
                });
              } else {
                ViewMode newView;
                if (value == 'List View')
                  newView = ViewMode.list;
                else
                  newView = ViewMode.card;

                setState(() {
                  _selectedView = newView;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              final textStyle = const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              );
              final activeTextStyle = textStyle.copyWith(
                fontWeight: FontWeight.w600,
              );

              return [
                PopupMenuItem(
                  value: 'Recent',
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recent',
                    style: _selectedSort == SortOption.recent
                        ? activeTextStyle
                        : textStyle,
                  ),
                ),
                PopupMenuItem(
                  value: 'Highest Rated',
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Highest Rated',
                    style: _selectedSort == SortOption.highestRated
                        ? activeTextStyle
                        : textStyle,
                  ),
                ),
                PopupMenuItem(
                  value: 'A-Z',
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'A-Z',
                    style: _selectedSort == SortOption.aToZ
                        ? activeTextStyle
                        : textStyle,
                  ),
                ),
                const PopupMenuDivider(height: 1),
                PopupMenuItem(
                  value: 'List View',
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'List View',
                    style: _selectedView == ViewMode.list
                        ? activeTextStyle
                        : textStyle,
                  ),
                ),
                PopupMenuItem(
                  value: 'Card View',
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Card View',
                    style: _selectedView == ViewMode.card
                        ? activeTextStyle
                        : textStyle,
                  ),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'My Bites'),
            Tab(text: 'Saved'),
          ],
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          if (_showFilterMenu) {
            setState(() {
              _showFilterMenu = false;
            });
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBitesList(_getSortedBites(_myBites)),
            _buildBitesList(_getSortedBites(_savedBites)),
          ],
        ),
      ),
    );
  }

  Widget _buildBitesList(List<Bite> bites) {
    if (_selectedView == ViewMode.list) {
      return ListView.builder(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 100,
        ),
        itemCount: bites.length,
        itemBuilder: (context, index) {
          return BiteListItem(
            bite: bites[index],
            onShare: _navigateToSendTo,
            onDelete: () => _deleteBite(bites[index].id),
          );
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 100,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: bites.length,
        itemBuilder: (context, index) {
          return BiteCardItem(bite: bites[index], onShare: _navigateToSendTo);
        },
      );
    }
  }
}
