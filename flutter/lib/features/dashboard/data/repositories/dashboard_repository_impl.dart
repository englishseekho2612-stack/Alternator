import 'dart:async';
import '../../domain/models/user_profile.dart';
import '../../domain/models/favorite_item.dart';
import '../../domain/models/conversation_metadata.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../../search/domain/models/search_history_item.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  // In-memory data store for localized simulation
  UserProfile? _cachedProfile;
  final List<FavoriteItem> _favorites = [];
  final List<SearchHistoryItem> _searchHistory = [];
  final List<ConversationMetadata> _conversations = [];

  DashboardRepositoryImpl() {
    _seedMockData();
  }

  void _seedMockData() {
    final now = DateTime.now();
    _cachedProfile = UserProfile(
      uid: 'uid_sanvi_user_99',
      displayName: 'Amrit Kumar',
      email: 'amrit@apps-alternator.in',
      profilePictureUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Felix',
      preferredLanguage: 'en',
      emailNotificationsEnabled: true,
      pushNotificationsEnabled: true,
      createdAt: now.subtract(const Duration(days: 45)),
      lastSyncedAt: now.subtract(const Duration(hours: 3)),
      isCloudSyncActive: true,
    );

    // Seed mock favorites
    _favorites.addAll([
      FavoriteItem(
        appName: 'GIMP',
        originalApp: 'Photoshop',
        category: 'Graphic Design',
        favoritedAt: now.subtract(const Duration(days: 5)),
        alternativeType: 'open_source',
      ),
      FavoriteItem(
        appName: 'Inkscape',
        originalApp: 'Illustrator',
        category: 'Vector Editor',
        favoritedAt: now.subtract(const Duration(days: 4)),
        alternativeType: 'open_source',
      ),
      FavoriteItem(
        appName: 'DaVinci Resolve',
        originalApp: 'Premiere Pro',
        category: 'Video Editing',
        favoritedAt: now.subtract(const Duration(days: 2)),
        alternativeType: 'commercial',
      ),
    ]);

    // Seed mock search history
    _searchHistory.addAll([
      SearchHistoryItem(query: 'Photoshop', timestamp: now.subtract(const Duration(hours: 2)), isFavorite: true),
      SearchHistoryItem(query: 'Microsoft Office', timestamp: now.subtract(const Duration(days: 1)), isFavorite: false),
      SearchHistoryItem(query: 'Figma Pro', timestamp: now.subtract(const Duration(days: 2)), isFavorite: false),
      SearchHistoryItem(query: 'Sublime Text', timestamp: now.subtract(const Duration(days: 5)), isFavorite: false),
    ]);

    // Seed previous conversations
    _conversations.addAll([
      ConversationMetadata(
        id: 'chat_sess_a00',
        title: 'Photoshop Alternatives on Linux',
        lastUpdatedAt: now.subtract(const Duration(hours: 4)),
        messageCount: 8,
      ),
      ConversationMetadata(
        id: 'chat_sess_b01',
        title: 'LibreOffice vs MS Office Compatibility',
        lastUpdatedAt: now.subtract(const Duration(days: 2)),
        messageCount: 14,
      ),
    ]);
  }

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _cachedProfile ??= UserProfile(
      uid: uid,
      displayName: 'New Apps Alternator User',
      email: 'user@apps-alternator.com',
      profilePictureUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Felix',
      preferredLanguage: 'en',
      emailNotificationsEnabled: true,
      pushNotificationsEnabled: true,
      createdAt: DateTime.now(),
      lastSyncedAt: DateTime.now(),
      isCloudSyncActive: true,
    );
  }

  @override
  Future<UserProfile> updateUserProfile(String uid, UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cachedProfile = profile;
    return _cachedProfile!;
  }

  @override
  Future<List<FavoriteItem>> getFavorites(String uid) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_favorites);
  }

  @override
  Future<List<FavoriteItem>> addFavorite(String uid, FavoriteItem item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!_favorites.any((x) => x.appName.toLowerCase() == item.appName.toLowerCase())) {
      _favorites.add(item);
    }
    return List.from(_favorites);
  }

  @override
  Future<List<FavoriteItem>> removeFavorite(String uid, String appName) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _favorites.removeWhere((x) => x.appName.toLowerCase() == appName.toLowerCase());
    return List.from(_favorites);
  }

  @override
  Future<List<SearchHistoryItem>> getSearchHistory(String uid) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_searchHistory);
  }

  @override
  Future<void> clearSearchHistory(String uid) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _searchHistory.clear();
  }

  @override
  Future<void> deleteHistoryItem(String uid, String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _searchHistory.removeWhere((x) => x.query.toLowerCase() == query.toLowerCase());
  }

  @override
  Future<void> saveSearchItem(String uid, String query) async {
    if (!_searchHistory.any((x) => x.query.toLowerCase() == query.toLowerCase())) {
      _searchHistory.insert(
        0,
        SearchHistoryItem(query: query, timestamp: DateTime.now(), isFavorite: false),
      );
    }
  }

  @override
  Future<List<ConversationMetadata>> getConversations(String uid) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_conversations);
  }

  @override
  Future<bool> synchronizeCloudData(String uid) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate server handshake
    if (_cachedProfile != null) {
      _cachedProfile = _cachedProfile!.copyWith(
        lastSyncedAt: DateTime.now(),
      );
    }
    return true;
  }

  @override
  Future<void> clearLocalStorageCache() async {
    await Future.delayed(const Duration(milliseconds: 150));
    _favorites.clear();
    _searchHistory.clear();
    _conversations.clear();
    _seedMockData(); // Reinitialize
  }
}
