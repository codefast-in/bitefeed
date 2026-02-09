import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/bite_model.dart';
import '../providers/bite_provider.dart';
import 'package:intl/intl.dart';
import './comments_bottom_sheet.dart';

class BiteListItem extends StatelessWidget {
  final BiteModel bite;
  final VoidCallback onShare;
  final VoidCallback? onDelete;
  final bool showDelete;

  const BiteListItem({
    super.key,
    required this.bite,
    required this.onShare,
    this.onDelete,
    this.showDelete = true,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                bite.photos.isNotEmpty ? bite.photos.first : '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.restaurant,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
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
                        color: index < bite.rating.toInt()
                            ? AppColors.primaryOrange
                            : Colors.grey[300],
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bite.restaurantName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMMM yyyy').format(bite.createdAt),
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                // Like button
                Consumer<BiteProvider>(
                  builder: (context, biteProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint('❤️ Tapping like for bite ${bite.id}');
                        biteProvider.toggleLike(bite.id);
                      },
                      child: Icon(
                        bite.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: bite.isLiked ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                    );
                  },
                ),
                Text(
                  '${bite.likesCount}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                // Bookmark button
                Consumer<BiteProvider>(
                  builder: (context, biteProvider, child) {
                    return GestureDetector(
                      onTap: () {
                        debugPrint('🔖 Tapping bookmark for bite ${bite.id}');
                        biteProvider.toggleBookmark(bite.id);
                      },
                      child: Icon(
                        bite.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: bite.isBookmarked
                            ? AppColors.primaryOrange
                            : Colors.grey,
                        size: 24,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Comment button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentsBottomSheet(bite: bite),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey,
                        size: 24,
                      ),
                      Text(
                        '${bite.commentsCount}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Share button
                GestureDetector(
                  onTap: onShare,
                  child: Container(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (showDelete && onDelete != null) {
      return Dismissible(
        key: Key(bite.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        onDismissed: (direction) => onDelete!(),
        child: widget,
      );
    }

    return widget;
  }
}
