import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
  List<BiteModel> _feedBites = [];
  List<BiteModel> _myBites = [];
  List<BiteModel> _savedBites = [];
  String? _errorMessage;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  // Bite interaction state
  String? _currentUserId;

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
  List<BiteModel> get feedBites => _feedBites;
  List<BiteModel> get myBites => _myBites;
  List<BiteModel> get bites => _feedBites; // Backward compatibility
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == BitesState.loading;
  bool get isCreating => _state == BitesState.creating;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _currentPage < _totalPages;
  int get currentPage => _currentPage;
  List<BiteModel> get savedBites => _savedBites;
  String? get currentUserId => _currentUserId;

  // Create bite flow getters
  List<XFile> get selectedImages => _selectedImages;
  List<String> get uploadedImageUrls => _uploadedImageUrls;
  String get restaurantName => _restaurantName;
  double get rating => _rating;
  String get caption => _caption;
  List<String> get tags => _tags;

  // Sync with AuthProvider
  void updateAuth(AuthProvider authProvider) {
    if (authProvider.currentUser?.id != _currentUserId) {
      debugPrint(
        '🔄 BiteProvider: User changed. Resetting bites data for ${authProvider.currentUser?.fullName}...',
      );
      _currentUserId = authProvider.currentUser?.id;
      clearData();
      if (_currentUserId != null) {
        loadBites();
      }
    }
  }

  // Reset all state (useful on logout/signup)
  void clearData() {
    _feedBites = [];
    _myBites = [];
    _savedBites = [];
    _currentPage = 1;
    _totalPages = 1;
    _isLoadingMore = false;
    _errorMessage = null;
    _state = BitesState.initial;
    resetCreateFlow();
    notifyListeners();
  }

  // Load bites (feed) - initial load
  Future<void> loadBites({
    bool refresh = false,
    int limit = 10,
    String sortBy = 'recent',
  }) async {
    if (refresh) {
      debugPrint('🍔 BiteProvider: Refreshing feed...');
      _currentPage = 1;
      _feedBites.clear();
    } else {
      debugPrint('🍔 BiteProvider: Loading feed page 1...');
    }

    _state = BitesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _biteRepository.getBitesFeed(
        page: 1,
        limit: limit,
        sortBy: sortBy,
        currentUserId: _currentUserId,
      );

      _feedBites = response['bites'];
      _currentPage = response['currentPage'];
      _totalPages = response['totalPages'];

      debugPrint(
        '✅ BiteProvider: Loaded ${_feedBites.length} bites (page 1/$_totalPages)',
      );
      _state = BitesState.loaded;
      notifyListeners();
    } on AppException catch (e) {
      debugPrint('❌ BiteProvider: Load feed failed - ${e.message}');
      _errorMessage = e.message;
      _state = BitesState.error;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ BiteProvider: Load feed error - $e');
      _errorMessage = 'An unexpected error occurred';
      _state = BitesState.error;
      notifyListeners();
    }
  }

  // Load more bites (pagination)
  Future<void> loadMoreBites({int limit = 10, String sortBy = 'recent'}) async {
    if (_isLoadingMore || !hasMore) {
      debugPrint(
        '⚠️ BiteProvider: Skip load more (loading=$_isLoadingMore, hasMore=$hasMore)',
      );
      return;
    }

    final nextPage = _currentPage + 1;
    debugPrint(
      '🍔 BiteProvider: Loading more bites page $nextPage/$_totalPages...',
    );

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _biteRepository.getBitesFeed(
        page: nextPage,
        limit: limit,
        sortBy: sortBy,
        currentUserId: _currentUserId,
      );

      _feedBites.addAll(response['bites']);
      _currentPage = response['currentPage'];
      _totalPages = response['totalPages'];

      debugPrint(
        '✅ BiteProvider: Loaded ${response['bites'].length} more bites (page $nextPage/$_totalPages)',
      );
      _isLoadingMore = false;
      notifyListeners();
    } on AppException catch (e) {
      debugPrint('❌ BiteProvider: Load more failed - ${e.message}');
      _errorMessage = e.message;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ BiteProvider: Load more error - $e');
      _errorMessage = 'An unexpected error occurred';
      _isLoadingMore = false;
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
      _myBites = await _biteRepository.getMyBites(
        page: page,
        limit: limit,
        sortBy: sortBy,
        currentUserId: _currentUserId,
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

    _state = BitesState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _uploadedImageUrls = await _biteRepository.uploadImages(_selectedImages);
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

  // Create bite
  Future<bool> createBite() async {
    if (_uploadedImageUrls.isEmpty || _restaurantName.isEmpty || _rating == 0) {
      _errorMessage = 'Please fill all required fields and upload images';
      debugPrint('⚠️ BiteProvider: Create bite validation failed');
      return false;
    }

    debugPrint('🍔 BiteProvider: Creating bite for $_restaurantName...');
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
        currentUserId: _currentUserId,
      );

      // Add to lists
      _feedBites.insert(0, newBite);
      _myBites.insert(0, newBite);
      debugPrint('✅ BiteProvider: Bite created successfully');

      // Reset create flow
      resetCreateFlow();

      _state = BitesState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      debugPrint('❌ BiteProvider: Create bite failed - ${e.message}');
      _errorMessage = e.message;
      _state = BitesState.error;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('❌ BiteProvider: Create bite error - $e');
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
      _feedBites.removeWhere((b) => b.id == biteId);
      _myBites.removeWhere((b) => b.id == biteId);
      _savedBites.removeWhere((b) => b.id == biteId);
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      return false;
    }
  }

  // Add comment
  Future<void> addComment(String biteId, String text) async {
    if (text.trim().isEmpty) return;

    try {
      final response = await _biteRepository.addComment(
        biteId: biteId,
        text: text,
      );

      // Extract comment from response
      final commentData = response['comment'] ?? response['data']?['comment'];

      // Update all lists
      _updateBiteInAllLists(biteId, (bite) {
        if (commentData != null) {
          final newComment = BiteComment.fromJson(commentData);
          final updatedComments = List<BiteComment>.from(bite.comments)
            ..add(newComment);
          return bite.copyWith(
            comments: updatedComments,
            commentsCount: bite.commentsCount + 1,
          );
        } else {
          return bite.copyWith(commentsCount: bite.commentsCount + 1);
        }
      });

      notifyListeners();
    } on AppException catch (e) {
      debugPrint('❌ BiteProvider: Add comment failed - ${e.message}');
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  // Fetch comments (if not loaded in feed)
  Future<void> getComments(String biteId) async {
    // Placeholder
  }

  // Toggle like
  Future<void> toggleLike(String biteId) async {
    try {
      _updateBiteInAllLists(biteId, (bite) {
        final oldLiked = bite.isLiked;
        final oldCount = bite.likesCount;
        return bite.copyWith(
          isLiked: !oldLiked,
          likesCount: oldLiked ? oldCount - 1 : oldCount + 1,
        );
      });
      notifyListeners();

      final response = await _biteRepository.toggleLike(biteId);

      // Update with server response
      _updateBiteInAllLists(
        biteId,
        (bite) => bite.copyWith(
          isLiked: response['isLiked'],
          likesCount: response['likesCount'],
        ),
      );
      notifyListeners();
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  // Toggle bookmark
  Future<void> toggleBookmark(String biteId) async {
    try {
      _updateBiteInAllLists(biteId, (bite) {
        final newBookmarked = !bite.isBookmarked;
        final updatedBite = bite.copyWith(isBookmarked: newBookmarked);

        // Handle savedBites list sync
        if (newBookmarked) {
          if (!_savedBites.any((b) => b.id == biteId)) {
            _savedBites.add(updatedBite);
          }
        } else {
          _savedBites.removeWhere((b) => b.id == biteId);
        }

        return updatedBite;
      });
      notifyListeners();

      await _biteRepository.toggleBookmark(biteId);
    } on AppException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
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

  void setThumbnail(XFile? file) {
    // Legacy mapping
  }

  void setCurrentUserId(String? id) {
    _currentUserId = id;
    notifyListeners();
  }

  // Load saved bites
  Future<void> loadSavedBites() async {
    // Collect bookmarked bites from all known lists
    final allBookmarked = [
      ..._feedBites.where((b) => b.isBookmarked),
      ..._myBites.where((b) => b.isBookmarked),
    ];

    // Unique list by ID
    final Map<String, BiteModel> uniqueBites = {};
    for (var b in allBookmarked) {
      uniqueBites[b.id] = b;
    }

    _savedBites = uniqueBites.values.toList();
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

  // Helper to get a bite by ID from any list
  BiteModel? getBiteById(String biteId) {
    return _feedBites.cast<BiteModel?>().firstWhere(
          (b) => b?.id == biteId,
          orElse: () => null,
        ) ??
        _myBites.cast<BiteModel?>().firstWhere(
          (b) => b?.id == biteId,
          orElse: () => null,
        ) ??
        _savedBites.cast<BiteModel?>().firstWhere(
          (b) => b?.id == biteId,
          orElse: () => null,
        );
  }

  // Helper to update a bite across all lists for state consistency
  void _updateBiteInAllLists(
    String biteId,
    BiteModel Function(BiteModel) updateFn,
  ) {
    // Update feed
    final feedIndex = _feedBites.indexWhere((b) => b.id == biteId);
    if (feedIndex != -1) {
      _feedBites[feedIndex] = updateFn(_feedBites[feedIndex]);
    }

    // Update my bites
    final myIndex = _myBites.indexWhere((b) => b.id == biteId);
    if (myIndex != -1) {
      _myBites[myIndex] = updateFn(_myBites[myIndex]);
    }

    // Update saved bites
    final savedIndex = _savedBites.indexWhere((b) => b.id == biteId);
    if (savedIndex != -1) {
      _savedBites[savedIndex] = updateFn(_savedBites[savedIndex]);
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
