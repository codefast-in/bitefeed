import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum SortOption { recent, highestRated, aToZ }

enum ViewMode { list, card }

class FilterMenu extends StatelessWidget {
  final SortOption selectedSort;
  final ViewMode selectedView;
  final Function(SortOption) onSortChanged;
  final Function(ViewMode) onViewChanged;

  const FilterMenu({
    super.key,
    required this.selectedSort,
    required this.selectedView,
    required this.onSortChanged,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuItem(
            'Recent',
            selectedSort == SortOption.recent,
            () => onSortChanged(SortOption.recent),
          ),
          _buildMenuItem(
            'Highest Rated',
            selectedSort == SortOption.highestRated,
            () => onSortChanged(SortOption.highestRated),
          ),
          _buildMenuItem(
            'A-Z',
            selectedSort == SortOption.aToZ,
            () => onSortChanged(SortOption.aToZ),
          ),
          const Divider(height: 1),
          _buildMenuItem(
            'List View',
            selectedView == ViewMode.list,
            () => onViewChanged(ViewMode.list),
          ),
          _buildMenuItem(
            'Card View',
            selectedView == ViewMode.card,
            () => onViewChanged(ViewMode.card),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.black : AppColors.textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
