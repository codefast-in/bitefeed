import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import '../../../bites/presentation/widgets/bite_list_item.dart';
import '../../../../core/config/app_config.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadOtherUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final otherUser = userProvider.otherUserProfile;
        final isLoading = userProvider.isLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: CustomPaint(painter: _GridPainter()),
            ),
            leading: IconButton(
              icon: Image.asset(
                'assets/icons/whiteBackIcon.png',
                width: 20,
                height: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (otherUser != null)
                PopupMenuButton<String>(
                  icon: Image.asset(
                    'assets/icons/otherUserDetailsOptionsIcon.png',
                    width: 24,
                    height: 24,
                  ),
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(0, 0, 28, 0),
                  onSelected: (value) {
                    if (value == 'Block') {
                      _showBlockDialog(context, otherUser.profile.id);
                    } else if (value == 'Report') {
                      _showReportDialog(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Block', 'Report'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          choice,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList();
                  },
                ),
            ],
          ),
          body: isLoading && otherUser == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  top: false,
                  left: false,
                  right: false,
                  bottom: true,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildProfileHeader(context, userProvider),
                      ),
                      if (otherUser != null && otherUser.bites.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => BiteListItem(
                                bite: otherUser.bites[index],
                                onShare: () {},
                              ),
                              childCount: otherUser.bites.length,
                            ),
                          ),
                        )
                      else if (otherUser != null)
                        const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No bites yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _showBlockDialog(BuildContext context, String targetUserId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Block User'),
        content: const Text('Are you sure you want to block this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await context
                  .read<UserProvider>()
                  .toggleBlockUser(targetUserId);
              if (success && mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('User Blocked')));
                Navigator.pop(context); // Go back after blocking
              }
            },
            child: const Text('Block', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: const Text('Are you sure you want to report this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('User Reported')));
            },
            child: const Text('Report', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    final size = MediaQuery.of(context).size;
    final otherUser = userProvider.otherUserProfile;
    if (otherUser == null) return const SizedBox.shrink();

    final profile = otherUser.profile;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: size.height * 0.12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: DecorationImage(
                    image: NetworkImage(
                      _absoluteUrl(profile.profileImage),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                profile.fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem('${profile.followersCount}', 'Followers'),
                  const SizedBox(width: 30),
                  Container(height: 40, width: 1, color: Colors.white24),
                  const SizedBox(width: 30),
                  _buildStatItem('${profile.followingCount}', 'Following'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        userProvider.toggleFollowUser(profile.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: profile.isFollowing
                            ? Colors.white24
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        profile.isFollowing ? 'Unfollow' : 'Follow',
                        style: TextStyle(
                          color: profile.isFollowing
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 140,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to chat
                        Navigator.pushNamed(
                          context,
                          '/chat',
                          arguments: {
                            'userId': profile.id,
                            'fullName': profile.fullName,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Message',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

  Widget _buildStatItem(String value, String label) {
    return Column(
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
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 60.0;

    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
