import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class AddDetailsStep extends StatefulWidget {
  final String restaurantName;
  final VoidCallback onBack;
  final VoidCallback onPost;
  final bool isLoading;
  final double rating;
  final Function(double) onRatingChanged;
  final String caption;
  final Function(String) onCaptionChanged;
  final List<String> tags;
  final Function(String) onAddTag;
  final Function(String) onRemoveTag;

  const AddDetailsStep({
    super.key,
    required this.restaurantName,
    required this.onBack,
    required this.onPost,
    this.isLoading = false,
    required this.rating,
    required this.onRatingChanged,
    required this.caption,
    required this.onCaptionChanged,
    required this.tags,
    required this.onAddTag,
    required this.onRemoveTag,
  });

  @override
  State<AddDetailsStep> createState() => _AddDetailsStepState();
}

class _AddDetailsStepState extends State<AddDetailsStep> {
  final TextEditingController _tagController = TextEditingController();
  late final TextEditingController _captionController;
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.caption);
    _captionController.addListener(() {
      widget.onCaptionChanged(_captionController.text);
    });
  }

  @override
  void dispose() {
    _tagController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  final List<String> _suggestedTags = [
    '#Vegan',
    '#Healthy',
    '#Dessert',
    '#LateNight',
    '#BudgetFriendly',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: widget.onBack,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 4),
              //   child: IconButton(
              //     padding: EdgeInsets.zero,
              //     constraints: const BoxConstraints(),
              //     icon: const Icon(
              //       Icons.arrow_back_ios_new,
              //       size: 20,
              //       color: Colors.black,
              //     ),
              //     onPressed: widget.onBack,
              //   ),
              // ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Add Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.restaurantName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20), // Balance for the smaller back button
            ],
          ),
          const SizedBox(height: 24),
          // Rating
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange.withOpacity(0.1),
                  AppColors.primaryRed.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Rate your Experience',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () =>
                          widget.onRatingChanged((index + 1).toDouble()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: index < widget.rating
                              ? AppColors.primaryRed
                              : AppColors.primaryRed.withOpacity(0.2),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Caption
          const Text(
            'Caption',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _captionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share Your Thoughts....',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Tags
          const Text(
            'Tags',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedTags.map((tag) {
              final isSelected = widget.tags.contains(tag);
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    widget.onRemoveTag(tag);
                  } else {
                    widget.onAddTag(tag);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.primaryGradient : null,
                    color: isSelected ? null : Colors.white,
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    hintText: '# Add Custom Tag',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_tagController.text.isNotEmpty) {
                    widget.onAddTag(
                      '#${_tagController.text.replaceAll('#', '')}',
                    );
                    _tagController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Privacy
          const Text(
            'Privacy',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPublic = true),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: _isPublic ? AppColors.primaryGradient : null,
                      color: _isPublic ? null : Colors.white,
                      border: _isPublic
                          ? null
                          : Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: _isPublic
                              ? Colors.white
                              : AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Public',
                          style: TextStyle(
                            color: _isPublic ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isPublic = false),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: !_isPublic ? AppColors.primaryGradient : null,
                      color: !_isPublic ? null : Colors.white,
                      border: !_isPublic
                          ? null
                          : Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: !_isPublic
                              ? Colors.white
                              : AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Private',
                          style: TextStyle(
                            color: !_isPublic ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: widget.onPost,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Post Bite',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
