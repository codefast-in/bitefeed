import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/create_bite/add_photos_step.dart';
import '../widgets/create_bite/tag_restaurant_step.dart';
import '../widgets/create_bite/custom_restaurant_step.dart';
import '../widgets/create_bite/add_details_step.dart';
import '../widgets/create_bite/success_step.dart';

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
  final List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();
  String? _selectedRestaurant;

  void _navigateTo(CreateBiteStep step) {
    setState(() => _currentStep = step);
  }

  Future<void> _capturePhoto() async {
    if (_photos.length >= 4) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _photos.add(File(photo.path)));
    }
  }

  Future<void> _uploadGallery() async {
    if (_photos.length >= 4) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        final remainingSlots = 4 - _photos.length;
        final imagesToAdd = images.take(remainingSlots);
        _photos.addAll(imagesToAdd.map((x) => File(x.path)));
      });
    }
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  void _createAnother() {
    setState(() {
      _currentStep = CreateBiteStep.addPhotos;
      _photos.clear();
      _selectedRestaurant = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding for keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(child: _buildCurrentStep()),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case CreateBiteStep.addPhotos:
        return AddPhotosStep(
          photos: _photos,
          onCapturePhoto: _capturePhoto,
          onUploadGallery: _uploadGallery,
          onRemovePhoto: _removePhoto,
          onNext: () => _navigateTo(CreateBiteStep.tagRestaurant),
        );

      case CreateBiteStep.tagRestaurant:
        return TagRestaurantStep(
          selectedRestaurant: _selectedRestaurant,
          onSelectRestaurant: (name) =>
              setState(() => _selectedRestaurant = name),
          onAddCustomRestaurant: () =>
              _navigateTo(CreateBiteStep.customRestaurant),
          onContinue: () => _navigateTo(CreateBiteStep.addDetails),
          onBack: () => _navigateTo(CreateBiteStep.addPhotos),
        );

      case CreateBiteStep.customRestaurant:
        return CustomRestaurantStep(
          onRestaurantAdded: (name) {
            setState(() => _selectedRestaurant = name);
            _navigateTo(CreateBiteStep.addDetails);
          },
          onBack: () => _navigateTo(CreateBiteStep.tagRestaurant),
        );

      case CreateBiteStep.addDetails:
        return AddDetailsStep(
          restaurantName: _selectedRestaurant!,
          onBack: () => _navigateTo(CreateBiteStep.tagRestaurant),
          onPost: () => _navigateTo(CreateBiteStep.success),
        );

      case CreateBiteStep.success:
        return SuccessStep(
          onViewInFeed: () {
            Navigator.pop(context);
            // Navigate to main/feed if needed, but since this is a modal
            // on top of main page, closing it reveals the feed/current page
          },
          onCreateAnother: _createAnother,
        );
    }
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
