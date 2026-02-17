import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../../../../core/config/app_config.dart';

class BlockListPage extends StatefulWidget {
  const BlockListPage({super.key});

  @override
  State<BlockListPage> createState() => _BlockListPageState();
}

class _BlockListPageState extends State<BlockListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadBlockedUsers(page: 1, limit: 10);
    });
  }

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
          'BLOCK LIST',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, _) {
          final isLoading = provider.isLoading;
          final blocked = provider.blockedUsers;
          if (isLoading && blocked.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (blocked.isEmpty) {
            return const Center(child: Text('No blocked users'));
          }
          return SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: true,
            child: RefreshIndicator(
              onRefresh: () async {
                await provider.loadBlockedUsers(page: 1, limit: 10);
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: blocked.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = blocked[index];
                  return _buildBlockItem(
                    name: item.user.fullName,
                    imageUrl: item.user.profileImage,
                    onUnblock: () async {
                      final ok =
                          await context.read<UserProvider>().toggleBlockUser(
                                item.user.id,
                              );
                      if (!mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User unblocked')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.errorMessage ??
                                  'Failed to unblock user',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlockItem({
    required String name,
    String? imageUrl,
    required VoidCallback onUnblock,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              _absoluteUrl(imageUrl),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: ElevatedButton(
              onPressed: onUnblock,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: const Text(
                'Unblock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
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
