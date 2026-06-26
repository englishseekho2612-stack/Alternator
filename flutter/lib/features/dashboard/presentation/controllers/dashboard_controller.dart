import 'package:flutter/foundation.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/favorite_item.dart';
import '../../domain/models/conversation_metadata.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../search/domain/models/search_history_item.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository _repository;

  UserProfile? _profile;
  List<FavoriteItem> _favorites = [];
  List<SearchHistoryItem> _searchHistory = [];
  List<ConversationMetadata> _conversations = [];

  bool _isLoading = false;
  bool _isSyncing = false;
  String? _errorMessage;

  UserProfile? get profile => _profile;
  List<FavoriteItem> get favorites => _favorites;
  List<SearchHistoryItem> get searchHistory => _searchHistory;
  List<ConversationMetadata> get conversations => _conversations;

  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  String? get errorMessage => _errorMessage;

  DashboardController(this._repository);

  /// Load complete dashboard metrics and user profiles
  Future<void> loadDashboardData(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getUserProfile(uid);
      _favorites = await _repository.getFavorites(uid);
      _searchHistory = await _repository.getSearchHistory(uid);
      _conversations = await _repository.getConversations(uid);
    } catch (e) {
      _errorMessage = 'Failed to load user dashboard: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update display details
  Future<bool> updateDisplayName(String uid, String newName) async {
    if (_profile == null) return false;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _profile!.copyWith(displayName: newName);
      _profile = await _repository.updateUserProfile(uid, updated);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile name: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Update language preferences
  Future<bool> updatePreferredLanguage(String uid, String lang) async {
    if (_profile == null) return false;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _profile!.copyWith(preferredLanguage: lang);
      _profile = await _repository.updateUserProfile(uid, updated);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update preferred language: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Toggle sync trigger
  Future<bool> toggleCloudSync(String uid, bool isActive) async {
    if (_profile == null) return false;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = _profile!.copyWith(isCloudSyncActive: isActive);
      _profile = await _repository.updateUserProfile(uid, updated);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to toggle cloud sync: $e';
      return false;
    } finally {
      notifyListeners();
    }
  }

  /// Save / Unsave favorites
  Future<void> toggleFavorite(String uid, FavoriteItem item) async {
    _errorMessage = null;
    try {
      final exists = _favorites.any((x) => x.appName.toLowerCase() == item.appName.toLowerCase());
      if (exists) {
        _favorites = await _repository.removeFavorite(uid, item.appName);
      } else {
        _favorites = await _repository.addFavorite(uid, item);
      }
    } catch (e) {
      _errorMessage = 'Failed to update favorites: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Remove single search item
  Future<void> removeHistoryItem(String uid, String query) async {
    _errorMessage = null;
    try {
      await _repository.deleteHistoryItem(uid, query);
      _searchHistory.removeWhere((x) => x.query.toLowerCase() == query.toLowerCase());
    } catch (e) {
      _errorMessage = 'Failed to delete history item: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Empty search history
  Future<void> clearAllSearchHistory(String uid) async {
    _errorMessage = null;
    try {
      await _repository.clearSearchHistory(uid);
      _searchHistory.clear();
    } catch (e) {
      _errorMessage = 'Failed to clear search history: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Trigger cloud synchronization manually
  Future<bool> syncNow(String uid) async {
    _isSyncing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.synchronizeCloudData(uid);
      if (result) {
        _profile = await _repository.getUserProfile(uid); // reload
      }
      return result;
    } catch (e) {
      _errorMessage = 'Synchronization failed: $e';
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Clear all cache and restore initial mock structure
  Future<void> resetCache(String uid) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.clearLocalStorageCache();
      await loadDashboardData(uid);
    } catch (e) {
      _errorMessage = 'Reset failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear active error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
