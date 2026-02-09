import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../bites/presentation/widgets/comments_bottom_sheet.dart';
import '../../../bites/presentation/providers/bite_provider.dart';
import '../../../bites/models/bite_model.dart';
import 'package:intl/intl.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final biteProvider = context.read<BiteProvider>();

      if (authProvider.currentUser != null) {
        biteProvider.setCurrentUserId(authProvider.currentUser!.id);
      }

      if (biteProvider.bites.isEmpty) {
        biteProvider.loadBites();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BiteProvider>().loadMoreBites();
    }
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    // Assuming images are served from the root of the server
    final baseUrl = AppConfig.apiBaseUrl.replaceAll('/api/v1', '');
    return '$baseUrl/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top section gradient background
          Container(
            height: 280,
            decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final user = authProvider.currentUser;
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.settings);
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: user?.profileImage != null
                                    ? CachedNetworkImage(
                                        imageUrl: _getImageUrl(
                                          user!.profileImage!,
                                        ),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(color: Colors.grey[200]),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                              'assets/images/userProfilePhoto.png',
                                              fit: BoxFit.cover,
                                            ),
                                      )
                                    : Image.asset(
                                        'assets/images/userProfilePhoto.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            user?.fullName ?? 'Guest',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.notifications,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/icons/blackFillNotificationIcon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Consumer<BiteProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading && provider.bites.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.errorMessage != null &&
                          provider.bites.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(provider.errorMessage!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.loadBites(refresh: true),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (provider.bites.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'No bites available yet.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    provider.loadBites(refresh: true),
                                child: const Text('Refresh'),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => provider.loadBites(refresh: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 100,
                          ),
                          itemCount:
                              provider.bites.length +
                              (provider.hasMore ? 1 : 1),
                          itemBuilder: (context, index) {
                            if (index < provider.bites.length) {
                              return _buildFeedItem(
                                context,
                                provider.bites[index],
                              );
                            } else {
                              if (provider.hasMore) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: Center(
                                    child: Text(
                                      'All bites viewed',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedItem(BuildContext context, BiteModel bite) {
    final biteProvider = context.read<BiteProvider>();

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.postDetails, arguments: bite),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: _getImageUrl(
                      bite.photos.isNotEmpty ? bite.photos.first : '',
                    ),
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 250,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: CachedNetworkImageProvider(
                              _getImageUrl(bite.user.profileImage),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bite.user.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black),
                              ],
                            ),
                          ),
                          Text(
                            bite.restaurantLocation?['address'] ??
                                'Unknown Location',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              shadows: const [
                                Shadow(blurRadius: 10, color: Colors.black),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(bite.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          shadows: const [
                            Shadow(blurRadius: 10, color: Colors.black),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.sendTo),
                    child: Image.asset(
                      'assets/icons/postMessageIcon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => biteProvider.toggleLike(bite.id),
                        child: Icon(
                          bite.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: bite.isLiked ? Colors.red : Colors.black,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('${bite.likesCount}'),
                      const SizedBox(width: 16),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                CommentsBottomSheet(bite: bite),
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/postCommentIcon.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 4),
                            Text('${bite.commentsCount}'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.sendTo),
                          child: Image.asset(
                            'assets/icons/postShearIcon.png',
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => biteProvider.toggleBookmark(bite.id),
                        child: Icon(
                          bite.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: bite.isBookmarked
                              ? AppColors.primaryOrange
                              : Colors.black,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bite.restaurantName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < bite.rating.toInt()
                                ? Colors.orange
                                : Colors.grey[300],
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (bite.caption != null && bite.caption!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(bite.caption!, style: const TextStyle(fontSize: 14)),
                  ],
                  if (bite.tags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      bite.tags.join(' '),
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
