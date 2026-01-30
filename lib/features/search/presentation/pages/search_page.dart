import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTrending = [];
  List<Map<String, dynamic>> _filteredNearby = [];

  final List<Map<String, dynamic>> _trendingData = [
    {
      'name': 'The Golden Fork',
      'image': 'assets/images/dish1.png',
      'rating': 5,
      'date': '28 November 2025',
    },
    {
      'name': 'Morning Brew Café',
      'image': 'assets/images/dish2.png',
      'rating': 5,
      'date': '28 November 2025',
    },
    {
      'name': 'Sweet Dreams Bakery',
      'image': 'assets/images/dish3.png',
      'rating': 5,
      'date': '28 November 2025',
    },
  ];

  final List<Map<String, dynamic>> _nearbyData = [
    {
      'name': 'Spice Paradise',
      'image': 'assets/images/dish4.png',
      'rating': 5,
      'date': '28 November 2025',
    },
    {
      'name': 'Ocean Breeze Restaurant',
      'image': 'assets/images/dish5.png',
      'rating': 5,
      'date': '28 November 2025',
    },
    {
      'name': 'Garden Fresh Bistro',
      'image': 'assets/images/dish1.png',
      'rating': 5,
      'date': '28 November 2025',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredTrending = _trendingData;
    _filteredNearby = _nearbyData;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTrending = _trendingData;
        _filteredNearby = _nearbyData;
      } else {
        _filteredTrending = _trendingData
            .where(
              (item) =>
                  item['name'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        _filteredNearby = _nearbyData
            .where(
              (item) =>
                  item['name'].toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () => Navigator.pop(context),
                        //   child: const Icon(
                        //     Icons.arrow_back_ios_new,
                        //     color: Colors.white,
                        //     size: 24,
                        //   ),
                        // ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'SEARCH',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 24), // Balance the back button
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterResults,
                        decoration: InputDecoration(
                          hintText: 'Cafe',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    _filterResults('');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      color: AppColors.textGrey,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/icons/searchCrossIcon.png',
                                      width: 12,
                                      height: 12,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_filteredTrending.isNotEmpty) ...[
                      const Text(
                        'Trending',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._filteredTrending.map(
                        (item) => _buildSearchResultCard(item),
                      ),
                    ],
                    if (_filteredNearby.isNotEmpty) ...[
                      // const SizedBox(height: 24),
                      const Text(
                        'Near By You',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._filteredNearby.map(
                        (item) => _buildSearchResultCard(item),
                      ),
                    ],
                    if (_filteredTrending.isEmpty &&
                        _filteredNearby.isEmpty) ...[
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.postDetails),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      item['rating'],
                      (index) => Image.asset(
                        'assets/icons/postStarFillIcon.png',
                        width: 16,
                        height: 16,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['date'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/icons/shearColorIcon.png',
                fit: BoxFit.cover,
                height: 16,
                width: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
