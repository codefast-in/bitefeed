import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../models/bite_model.dart';
import '../providers/bite_provider.dart';
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
  SortOption _selectedSort = SortOption.recent;
  ViewMode _selectedView = ViewMode.list;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load My Bites when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMyBites();
    });

    // Listen to tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          _loadMyBites();
        } else {
          debugPrint('🔖 Loading saved bites...');
          context.read<BiteProvider>().loadSavedBites();
        }
      }
    });
  }

  void _loadMyBites() {
    final biteProvider = Provider.of<BiteProvider>(context, listen: false);
    debugPrint('📱 BitesPage: Loading my bites...');
    biteProvider.loadMyBites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BiteModel> _getSortedBites(List<BiteModel> bites) {
    List<BiteModel> sorted = List.from(bites);

    switch (_selectedSort) {
      case SortOption.recent:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
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

  Future<void> _deleteBite(String id) async {
    final biteProvider = Provider.of<BiteProvider>(context, listen: false);
    debugPrint('🗑️ BitesPage: Deleting bite $id...');

    final success = await biteProvider.deleteBite(id);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bite deleted successfully')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(biteProvider.errorMessage ?? 'Failed to delete bite'),
        ),
      );
    }
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
      body: Consumer<BiteProvider>(
        builder: (context, biteProvider, child) {
          if (biteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (biteProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(biteProvider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMyBites,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBitesList(
                _getSortedBites(biteProvider.myBites),
                showDelete: true,
              ),
              _buildBitesList(
                _getSortedBites(biteProvider.savedBites),
                showDelete: false,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBitesList(List<BiteModel> bites, {required bool showDelete}) {
    if (bites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              showDelete ? 'No bites yet' : 'No saved bites',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

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
            onDelete: showDelete ? () => _deleteBite(bites[index].id) : null,
            showDelete: showDelete,
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
