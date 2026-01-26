import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class TagRestaurantStep extends StatelessWidget {
  final String? selectedRestaurant;
  final Function(String) onSelectRestaurant;
  final VoidCallback onAddCustomRestaurant;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const TagRestaurantStep({
    super.key,
    required this.selectedRestaurant,
    required this.onSelectRestaurant,
    required this.onAddCustomRestaurant,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final restaurants = [
      {'name': 'The Golden Fork', 'address': '123 Main St, Downtown'},
      {'name': 'Morning Brew Café', 'address': '123 Main St, Downtown'},
      {'name': 'Sweet Bakery', 'address': '123 Main St, Downtown'},
      {'name': 'Sakura Sushi Bar', 'address': '123 Main St, Downtown'},
      {'name': 'Bella\'s Pizzeria', 'address': '123 Main St, Downtown'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                onPressed: onBack,
              ),
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'Tag Restaurant',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Where Did You Eat?',
                      style: TextStyle(fontSize: 16, color: AppColors.textGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search Restaurant',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primaryOrange,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: restaurants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                final isSelected = selectedRestaurant == restaurant['name'];

                return GestureDetector(
                  onTap: () {
                    onSelectRestaurant(restaurant['name']!);
                    onContinue();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : Colors.white,
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFFDF5ED),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              restaurant['address']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.9)
                                    : AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onAddCustomRestaurant,
            icon: const Icon(Icons.add),
            label: const Text('Add Custom Restaurant'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryOrange,
              side: const BorderSide(color: AppColors.primaryOrange),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
