import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apps_alternator/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:apps_alternator/features/dashboard/domain/models/user_profile.dart';
import 'package:apps_alternator/features/dashboard/domain/models/favorite_item.dart';
import 'package:apps_alternator/features/dashboard/domain/models/conversation_metadata.dart';
import 'package:apps_alternator/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:apps_alternator/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:apps_alternator/features/search/domain/models/search_history_item.dart';

class MockDashboardRepository implements DashboardRepository {
  UserProfile? mockProfile;

  MockDashboardRepository() {
    mockProfile = UserProfile(
      uid: 'user_123',
      displayName: 'Test Amrit',
      email: 'test.amrit@gmail.com',
      profilePictureUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      preferredLanguage: 'en',
      emailNotificationsEnabled: true,
      pushNotificationsEnabled: true,
      createdAt: DateTime.now(),
      lastSyncedAt: DateTime.now(),
      isCloudSyncActive: true,
    );
  }

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    return mockProfile!;
  }

  @override
  Future<UserProfile> updateUserProfile(String uid, UserProfile profile) async {
    mockProfile = profile;
    return mockProfile!;
  }

  @override
  Future<List<FavoriteItem>> getFavorites(String uid) async {
    return [
      FavoriteItem(
        appName: 'Krita',
        originalApp: 'Photoshop',
        category: 'Graphics',
        favoritedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<FavoriteItem>> addFavorite(String uid, FavoriteItem item) async => [];

  @override
  Future<List<FavoriteItem>> removeFavorite(String uid, String appName) async => [];

  @override
  Future<List<SearchHistoryItem>> getSearchHistory(String uid) async {
    return [SearchHistoryItem(query: 'Photoshop', timestamp: DateTime.now())];
  }

  @override
  Future<void> clearSearchHistory(String uid) async {}

  @override
  Future<void> deleteHistoryItem(String uid, String query) async {}

  @override
  Future<void> saveSearchItem(String uid, String query) async {}

  @override
  Future<List<ConversationMetadata>> getConversations(String uid) async {
    return [];
  }

  @override
  Future<bool> synchronizeCloudData(String uid) async => true;

  @override
  Future<void> clearLocalStorageCache() async {}
}

void main() {
  group('DashboardView Widget and State Tests', () {
    late MockDashboardRepository mockRepo;
    late DashboardController controller;

    setUp(() {
      mockRepo = MockDashboardRepository();
      controller = DashboardController(mockRepo);
    });

    testWidgets('Renders User Profile info properly after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardView(
            controller: controller,
            userId: 'user_123',
          ),
        ),
      );

      // Verify that initially the loader runs
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Settle all futures and state notifications
      await tester.pumpAndSettle();

      // Verify profile text displays
      expect(find.text('Test Amrit'), findsOneWidget);
      expect(find.text('Email: test.amrit@gmail.com'), findsOneWidget);
      expect(find.text('Krita'), findsOneWidget);
      expect(find.text('Alternative for Photoshop'), findsOneWidget);
    });

    testWidgets('Toggles Cloud Sync and notifies listeners', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardView(
            controller: controller,
            userId: 'user_123',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Click Cloud Sync item to toggle
      await tester.tap(find.text('Cloud Synchronization'));
      await tester.pumpAndSettle();

      // Verify update function is triggered on repository
      expect(mockRepo.mockProfile!.isCloudSyncActive, isFalse);
    });
  });
}
