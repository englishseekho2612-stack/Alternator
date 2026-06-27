import 'dart:io';
import 'dart:async';
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

    setUpAll(() {
      HttpOverrides.global = MockHttpOverrides();
    });

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

      // Trigger post frame callback which sets isLoading to true
      await tester.pump();

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

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return MockHttpClientRequest();
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('get', url);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  bool persistentConnection = false;

  @override
  bool followRedirects = false;

  @override
  int maxRedirects = 0;

  @override
  int contentLength = 0;

  @override
  bool bufferOutput = false;

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }

  @override
  Future<HttpClientResponse> get done => Future.value(MockHttpClientResponse());

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpHeaders implements HttpHeaders {
  @override
  bool chunkedTransferEncoding = false;

  @override
  bool persistentConnection = false;

  @override
  int? port;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}

class MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  static const List<int> _transparentImage = [
    0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00,
    0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0x21, 0xF9, 0x04, 0x01, 0x00,
    0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00,
    0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3B
  ];

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  bool get isRedirect => false;

  @override
  List<RedirectInfo> get redirects => [];

  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  bool get persistentConnection => false;

  @override
  String get reasonPhrase => 'OK';

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return null;
  }
}
