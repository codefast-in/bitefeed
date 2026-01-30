import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../models/bite_model.dart';
import 'package:intl/intl.dart';

class BiteCardItem extends StatelessWidget {
  final Bite bite;
  final VoidCallback onShare;

  const BiteCardItem({super.key, required this.bite, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  bite.imageUrl,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onShare,
                   child: Container(
    padding: const EdgeInsets.all(8),

    decoration: BoxDecoration(
    border: Border.all(color: AppColors.black),
    borderRadius: BorderRadius.circular(8),
      color: AppColors.white
    ),
    child: Image.asset(
    'assets/icons/shearColorIcon.png',
    fit: BoxFit.cover,
    height: 16,
    width: 16,
    ),
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
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      color: index < bite.rating
                          ? AppColors.primaryOrange
                          : Colors.grey[300],
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  bite.restaurantName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMMM yyyy').format(bite.date),
                  style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
