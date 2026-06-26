import '../models/user_profile.dart';
import '../models/favorite_item.dart';
import '../models/conversation_metadata.dart';
import '../../../search/domain/models/search_history_item.dart';

abstract class DashboardRepository {
  /// Fetch the current active user profile details
  Future<UserProfile> getUserProfile(String uid);

  /// Update the current user profile metadata
  Future<UserProfile> updateUserProfile(String uid, UserProfile profile);

  /// Fetch user saved favorite alternatives
  Future<List<FavoriteItem>> getFavorites(String uid);

  /// Add application to favorites
  Future<List<FavoriteItem>> addFavorite(String uid, FavoriteItem item);

  /// Remove application from favorites
  Future<List<FavoriteItem>> removeFavorite(String uid, String appName);

  /// Fetch user recent searches list
  Future<List<SearchHistoryItem>> getSearchHistory(String uid);

  /// Clear user local and cloud search histories
  Future<void> clearSearchHistory(String uid);

  /// Remove single item from history list
  Future<void> deleteHistoryItem(String uid, String query);

  /// Save new query to history list
  Future<void> saveSearchItem(String uid, String query);

  /// Fetch metadata list of previous AI conversation histories
  Future<List<ConversationMetadata>> getConversations(String uid);

  /// Trigger cloud synchronization with safe conflict resolution
  Future<bool> synchronizeCloudData(String uid);

  /// Reset cache database helper
  Future<void> clearLocalStorageCache();
}
