import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../presentation/providers/search_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../bites/models/bite_model.dart';
import '../../../../core/config/app_config.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    final provider = context.read<SearchProvider>();
    if (query.trim().isEmpty) {
      provider.clearSearch();
    } else {
      provider.search(query.trim(), page: 1, limit: 10);
    }
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
                        onChanged: _onQueryChanged,
                        decoration: InputDecoration(
                          hintText: 'Search users or cafes',
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
                                    context.read<SearchProvider>().clearSearch();
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
                    Consumer<SearchProvider>(
                      builder: (context, provider, _) {
                        if (provider.isSearching) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final users = provider.users;
                        final bites = provider.bites;

                        if (users.isEmpty && bites.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          );
                        }

                        if (users.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Users',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...users.map(_buildUserCard),
                            ],
                          );
                        }

                        // Otherwise show cafes (bites) design
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cafes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...bites.map(_buildCafeCard),
                          ],
                        );
                      },
                    ),
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

  Widget _buildUserCard(UserModel user) {
    final imageUrl = _absoluteUrl(
      (user.profileImage != null && user.profileImage!.isNotEmpty)
          ? user.profileImage!
          : null,
    );
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.userDetails,
        arguments: user.id,
      ),
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
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildCafeCard(BiteModel bite) {
    final imageUrl = _absoluteUrl(
      (bite.photos.isNotEmpty) ? bite.photos.first : null,
    );
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.postDetails, arguments: bite),
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
              child: Image.network(
                imageUrl,
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
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 16,
                        color: index < bite.rating.toInt()
                            ? AppColors.primaryOrange
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bite.restaurantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

  String _absoluteUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'https://i.pravatar.cc/150';
    }
    if (path.startsWith('http')) return path;
    final base = AppConfig.apiBaseUrl.replaceAll('/api/v1', '');
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$base$normalized';
  }
}
