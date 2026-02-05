import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/bite_repository.dart';
import '../../models/bite_model.dart';
import '../../../../core/network/api_exception.dart';

enum BitesState { initial, loading, loaded, creating, error }

class BiteProvider extends ChangeNotifier {
  final BiteRepository _biteRepository;

  BiteProvider({BiteRepository? biteRepository})
    : _biteRepository = biteRepository ?? BiteRepository();

  // State
  BitesState _state = BitesState.initial;
  List<BiteModel> _bites = [];
  String? _errorMessage;

  // Create bite flow state
  List<XFile> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  String _restaurantName = '';
  double _rating = 0;
  String _caption = '';
  List<String> _tags = [];
  Map<String, dynamic>? _restaurantLocation;

  // Getters
  BitesState get state => _state;
  List<BiteModel> get bites => _bites;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == BitesState.loading;
  bool get isCreating => _state == BitesState.creating;

  // Create bite flow getters
  List<XFile> get selectedImages => _selectedImages;
  List<String> get uploadedImageUrls => _uploadedImageUrls;
  String get restaurantName => _restaurantName;
  double get rating => _rating;
  String get caption => _caption;
  List<String> get tags => _tags;

  // Load bites (feed)
  Future<void> loadBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'recent',
  }) async {
    _state = BitesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bites = await _biteRepository.getBites(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
      _state = BitesState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = BitesState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = BitesState.error;
      notifyListeners();
    }
  }

  // Load my bites
  Future<void> loadMyBites({
    int page = 1,
    int limit = 10,
    String sortBy = 'newest',
  }) async {
    _state = BitesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _bites = await _biteRepository.getMyBites(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );
      _state = BitesState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = BitesState.error;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = BitesState.error;
      notifyListeners();
    }
  }

  // Upload images
  Future<bool> uploadImages() async {
    if (_selectedImages.isEmpty) {
      _errorMessage = 'Please select images';
      return false;
    }

    try {
      _uploadedImageUrls = await _biteRepository.uploadImages(_selectedImages);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Create bite
  Future<bool> createBite() async {
    if (_uploadedImageUrls.isEmpty || _restaurantName.isEmpty || _rating == 0) {
      _errorMessage = 'Please fill all required fields and upload images';
      return false;
    }

    _state = BitesState.creating;
    _errorMessage = null;
    notifyListeners();

    try {
      final newBite = await _biteRepository.createBite(
        restaurantName: _restaurantName,
        photos: _uploadedImageUrls,
        rating: _rating,
        caption: _caption.isNotEmpty ? _caption : null,
        tags: _tags.isNotEmpty ? _tags : null,
        restaurantLocation: _restaurantLocation,
      );

      // Add to list
      _bites.insert(0, newBite);

      // Reset create flow
      resetCreateFlow();

      _state = BitesState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = BitesState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _state = BitesState.error;
      notifyListeners();
      return false;
    }
  }

  // Delete bite
  Future<bool> deleteBite(String biteId) async {
    try {
      await _biteRepository.deleteBite(biteId);
      _bites.removeWhere((b) => b.id == biteId);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Toggle like
  Future<void> toggleLike(String biteId) async {
    try {
      // Optimistic update
      final index = _bites.indexWhere((b) => b.id == biteId);
      if (index != -1) {
        _bites[index] = _bites[index].copyWith(
          isLiked: !_bites[index].isLiked,
          likesCount: _bites[index].isLiked
              ? _bites[index].likesCount - 1
              : _bites[index].likesCount + 1,
        );
        notifyListeners();
      }

      await _biteRepository.toggleLike(biteId);
    } on AppException catch (e) {
      // Revert on error
      final index = _bites.indexWhere((b) => b.id == biteId);
      if (index != -1) {
        _bites[index] = _bites[index].copyWith(
          isLiked: !_bites[index].isLiked,
          likesCount: _bites[index].isLiked
              ? _bites[index].likesCount - 1
              : _bites[index].likesCount + 1,
        );
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark(String biteId) async {
    try {
      // Optimistic update
      final index = _bites.indexWhere((b) => b.id == biteId);
      if (index != -1) {
        _bites[index] = _bites[index].copyWith(
          isBookmarked: !_bites[index].isBookmarked,
        );
        notifyListeners();
      }

      await _biteRepository.toggleBookmark(biteId);
    } on AppException catch (e) {
      // Revert on error
      final index = _bites.indexWhere((b) => b.id == biteId);
      if (index != -1) {
        _bites[index] = _bites[index].copyWith(
          isBookmarked: !_bites[index].isBookmarked,
        );
        notifyListeners();
      }
      _errorMessage = e.message;
    }
  }

  // Create bite flow methods
  void setSelectedImages(List<XFile> images) {
    _selectedImages = images;
    notifyListeners();
  }

  void addImage(XFile image) {
    _selectedImages.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void setRestaurantName(String name) {
    _restaurantName = name;
    notifyListeners();
  }

  void setRating(double value) {
    _rating = value;
    notifyListeners();
  }

  void setCaption(String value) {
    _caption = value;
    notifyListeners();
  }

  void setTags(List<String> value) {
    _tags = value;
    notifyListeners();
  }

  void addTag(String tag) {
    if (!_tags.contains(tag)) {
      _tags.add(tag);
      notifyListeners();
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
    notifyListeners();
  }

  void setRestaurantLocation(Map<String, dynamic> location) {
    _restaurantLocation = location;
    notifyListeners();
  }

  void resetCreateFlow() {
    _selectedImages = [];
    _uploadedImageUrls = [];
    _restaurantName = '';
    _rating = 0;
    _caption = '';
    _tags = [];
    _restaurantLocation = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
