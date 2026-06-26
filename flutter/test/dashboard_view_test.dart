import 'dart:io';
import 'dart:convert';
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
  Future<HttpClientRequest> openUrl(String method, Uri url) async {
    return MockHttpClientRequest();
  }

  @override
  set connectionTimeout(Duration? value) {}

  @override
  Duration? get connectionTimeout => null;

  @override
  set maxConnectionsPerHost(int? value) {}

  @override
  int? get maxConnectionsPerHost => null;

  @override
  set autoUncompress(bool value) {}

  @override
  bool get autoUncompress => true;

  @override
  set userAgent(String? value) {}

  @override
  String? get userAgent => null;

  @override
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials) {}

  @override
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials) {}

  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  set authenticate(Future<bool> Function(Uri url, String scheme, String? realm)? f) {}

  @override
  set authenticateProxy(Future<bool> Function(String host, int port, String scheme, String? realm)? f) {}

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}

  @override
  void close({bool force = false}) {}

  @override
  Future<HttpClientRequest> get(String host, int port, String path) => openUrl('get', Uri.parse(''));

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('get', url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) => openUrl('post', Uri.parse(''));

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('post', url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) => openUrl('put', Uri.parse(''));

  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl('put', url);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) => openUrl('delete', Uri.parse(''));

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl('delete', url);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) => openUrl('head', Uri.parse(''));

  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl('head', url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) => openUrl('patch', Uri.parse(''));

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl('patch', url);

  @override
  set keyLog(Function(String line)? callback) {}

  @override
  set connectionFactory(Future<ConnectionTask<Socket>> Function(Uri url, String? proxyHost, int? proxyPort)? f) {}
}

class MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse();
  }

  @override
  void add(List<int> data) {}

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future addStream(Stream<List<int>> stream) async {}

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding _encoding) {}

  @override
  void write(Object? obj) {}

  @override
  void writeAll(Iterable objects, [String separator = ""]) {}

  @override
  void writeCharCode(int charCode) {}

  @override
  void writeln([Object? obj = ""]) {}

  @override
  Future get done => Future.value();

  @override
  set bufferOutput(bool _bufferOutput) {}

  @override
  bool get bufferOutput => true;

  @override
  set contentLength(int _contentLength) {}

  @override
  int get contentLength => 0;

  @override
  bool get followRedirects => true;

  @override
  set followRedirects(bool _followRedirects) {}

  @override
  int get maxRedirects => 5;

  @override
  set maxRedirects(int _maxRedirects) {}

  @override
  bool get persistentConnection => true;

  @override
  set persistentConnection(bool _persistentConnection) {}

  @override
  Uri get uri => Uri.parse('');

  @override
  String get method => '';

  @override
  HttpConnectionInfo? get connectionInfo => null;

  @override
  set cookies(List<Cookie> _cookies) {}

  @override
  List<Cookie> get cookies => [];
}

class MockHttpHeaders implements HttpHeaders {
  @override
  List<String>? operator [](String name) => null;

  @override
  String? value(String name) => null;

  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void remove(String name, Object value) {}

  @override
  void removeAll(String name) {}

  @override
  void forEach(void Function(String name, List<String> values) action) {}

  @override
  void noFolding(String name) {}

  @override
  set date(DateTime? _date) {}

  @override
  DateTime? get date => null;

  @override
  set expires(DateTime? _expires) {}

  @override
  DateTime? get expires => null;

  @override
  set ifModifiedSince(DateTime? _ifModifiedSince) {}

  @override
  DateTime? get ifModifiedSince => null;

  @override
  set host(String? _host) {}

  @override
  String? get host => null;

  @override
  set port(int? _port) {}

  @override
  int? get port => null;

  @override
  set contentType(ContentType? _contentType) {}

  @override
  ContentType? get contentType => null;

  @override
  set contentLength(int _contentLength) {}

  @override
  int get contentLength => 0;

  @override
  set chunkedTransferEncoding(bool _chunkedTransferEncoding) {}

  @override
  bool get chunkedTransferEncoding => false;

  @override
  set persistentConnection(bool _persistentConnection) {}

  @override
  bool get persistentConnection => true;

  @override
  void clear() {}
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
  String get reasonPhrase => 'OK';

  @override
  int get contentLength => _transparentImage.length;

  @override
  set contentLength(int _contentLength) {}

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  List<Cookie> get cookies => [];

  @override
  bool get isRedirect => false;

  @override
  PersistentConnectionState get persistentConnectionState =>
      PersistentConnectionState.persisted;

  @override
  List<RedirectInfo> get redirects => [];

  @override
  Future<HttpClientResponse> redirect([String? method, Uri? url, bool? followRedirects]) {
    throw UnimplementedError();
  }

  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  HttpConnectionInfo? get connectionInfo => null;
}
