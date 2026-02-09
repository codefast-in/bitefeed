import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/create_bite/add_photos_step.dart';
import '../widgets/create_bite/tag_restaurant_step.dart';
import '../widgets/create_bite/custom_restaurant_step.dart';
import '../widgets/create_bite/add_details_step.dart';
import '../widgets/create_bite/success_step.dart';
import '../providers/bite_provider.dart';

enum CreateBiteStep {
  addPhotos,
  tagRestaurant,
  customRestaurant,
  addDetails,
  success,
}

class CreateBiteSheet extends StatefulWidget {
  const CreateBiteSheet({super.key});

  @override
  State<CreateBiteSheet> createState() => _CreateBiteSheetState();
}

class _CreateBiteSheetState extends State<CreateBiteSheet> {
  CreateBiteStep _currentStep = CreateBiteStep.addPhotos;

  void _navigateTo(CreateBiteStep step) {
    setState(() => _currentStep = step);
  }

  Future<void> _handlePhotoStepNext() async {
    final provider = Provider.of<BiteProvider>(context, listen: false);
    if (provider.selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one photo')),
      );
      return;
    }

    final success = await provider.uploadImages();
    if (success) {
      _navigateTo(CreateBiteStep.tagRestaurant);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Upload failed')),
        );
      }
    }
  }

  Future<void> _handlePost() async {
    final provider = Provider.of<BiteProvider>(context, listen: false);
    final success = await provider.createBite();
    if (success) {
      _navigateTo(CreateBiteStep.success);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Failed to create bite'),
          ),
        );
      }
    }
  }

  void _createAnother() {
    final provider = Provider.of<BiteProvider>(context, listen: false);
    provider.resetCreateFlow();
    setState(() {
      _currentStep = CreateBiteStep.addPhotos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding for keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        bottom: true,
        child: SingleChildScrollView(child: _buildCurrentStep()),
      ),
    );
  }

  Widget _buildCurrentStep() {
    return Consumer<BiteProvider>(
      builder: (context, provider, child) {
        switch (_currentStep) {
          case CreateBiteStep.addPhotos:
            return AddPhotosStep(
              photos: provider.selectedImages,
              onCapturePhoto: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) provider.addImage(photo);
              },
              onUploadGallery: () async {
                final ImagePicker picker = ImagePicker();
                final List<XFile> images = await picker.pickMultiImage();
                for (var img in images) {
                  if (provider.selectedImages.length < 4) {
                    provider.addImage(img);
                  }
                }
              },
              onRemovePhoto: provider.removeImage,
              onNext: _handlePhotoStepNext,
              isLoading: provider.isLoading,
            );

          case CreateBiteStep.tagRestaurant:
            return TagRestaurantStep(
              selectedRestaurant: provider.restaurantName,
              onSelectRestaurant: (name, location) {
                provider.setRestaurantName(name);
                if (location != null) provider.setRestaurantLocation(location);
              },
              onAddCustomRestaurant: () =>
                  _navigateTo(CreateBiteStep.customRestaurant),
              onContinue: () => _navigateTo(CreateBiteStep.addDetails),
              onBack: () => _navigateTo(CreateBiteStep.addPhotos),
            );

          case CreateBiteStep.customRestaurant:
            return CustomRestaurantStep(
              onRestaurantAdded: (name) {
                provider.setRestaurantName(name);
                _navigateTo(CreateBiteStep.addDetails);
              },
              onBack: () => _navigateTo(CreateBiteStep.tagRestaurant),
            );

          case CreateBiteStep.addDetails:
            return AddDetailsStep(
              restaurantName: provider.restaurantName,
              onBack: () => _navigateTo(CreateBiteStep.tagRestaurant),
              onPost: _handlePost,
              isLoading: provider.isCreating,
              rating: provider.rating,
              onRatingChanged: provider.setRating,
              caption: provider.caption,
              onCaptionChanged: provider.setCaption,
              tags: provider.tags,
              onAddTag: provider.addTag,
              onRemoveTag: provider.removeTag,
            );

          case CreateBiteStep.success:
            return SuccessStep(
              onViewInFeed: () {
                Navigator.pop(context);
              },
              onCreateAnother: _createAnother,
            );
        }
      },
    );
  }
}

void showCreateBiteSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CreateBiteSheet(),
  );
}
