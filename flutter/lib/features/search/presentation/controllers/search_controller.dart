import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/app_info.dart';
import '../../domain/models/search_history_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../../data/repositories/search_repository_impl.dart';

/// State representation for Apps Alternator AI Search Engine
class SearchState {
  final bool isLoading;
  final String? error;
  final AppInfo? currentResult;
  final List<SearchHistoryItem> searchHistory;
  final List<SearchHistoryItem> favorites;
  final List<Map<String, String>> chatMessages;
  final bool isChatLoading;

  SearchState({
    this.isLoading = false,
    this.error,
    this.currentResult,
    this.searchHistory = const [],
    this.favorites = const [],
    this.chatMessages = const [],
    this.isChatLoading = false,
  });

  SearchState copyWith({
    bool? isLoading,
    String? error,
    AppInfo? currentResult,
    List<SearchHistoryItem>? searchHistory,
    List<SearchHistoryItem>? favorites,
    List<Map<String, String>>? chatMessages,
    bool? isChatLoading,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can set to null explicitly
      currentResult: currentResult ?? this.currentResult,
      searchHistory: searchHistory ?? this.searchHistory,
      favorites: favorites ?? this.favorites,
      chatMessages: chatMessages ?? this.chatMessages,
      isChatLoading: isChatLoading ?? this.isChatLoading,
    );
  }
}

/// Provider of the SearchRepository implementation
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl();
});

/// Riverpod StateNotifier managing the AI search experiences
class AppSearchController extends StateNotifier<SearchState> {
  final SearchRepository _repository;

  AppSearchController(this._repository) : super(SearchState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final history = await _repository.getSearchHistory();
      final favorites = await _repository.getFavorites();
      state = state.copyWith(
        searchHistory: history,
        favorites: favorites,
        chatMessages: [
          {
            'sender': 'sanvi',
            'content': 'Namaste! 🙏 I am Sanvi, your AI Companion. Search any app to find verified alternatives, or talk to me right here!'
          }
        ]
      );
    } catch (_) {}
  }

  /// Triggers full AI Search for an app
  Future<void> searchApp(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      state = state.copyWith(error: 'Please enter an application name to search.');
      return;
    }

    if (trimmedQuery.length > 100) {
      state = state.copyWith(error: 'Application name is too long. Please restrict to under 100 characters.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.searchApplication(trimmedQuery);
      final history = await _repository.getSearchHistory();
      
      state = state.copyWith(
        isLoading: false,
        currentResult: result,
        searchHistory: history,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Search failed. Please verify internet connection and retry.',
      );
    }
  }

  /// Interactive conversational chat with Sanvi
  Future<void> sendChatMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

    var finalMessage = trimmedMessage;
    if (finalMessage.length > 500) {
      finalMessage = '${finalMessage.substring(0, 500)}...';
    }

    final updatedMessages = List<Map<String, String>>.from(state.chatMessages);
    updatedMessages.add({'sender': 'user', 'content': finalMessage});

    state = state.copyWith(
      chatMessages: updatedMessages,
      isChatLoading: true,
    );

    try {
      // Submits message and logs history to the Gemini Repository
      final reply = await _repository.chatWithSanvi(finalMessage, updatedMessages);
      
      final finalMessages = List<Map<String, String>>.from(state.chatMessages);
      finalMessages.add({'sender': 'sanvi', 'content': reply});

      state = state.copyWith(
        chatMessages: finalMessages,
        isChatLoading: false,
      );
    } catch (e) {
      final finalMessages = List<Map<String, String>>.from(state.chatMessages);
      finalMessages.add({
        'sender': 'sanvi',
        'content': 'Main khed vyakt karti hoon, abhi mere servers thode busy hain. Kripya thodi der baad prayaas karein!'
      });
      state = state.copyWith(
        chatMessages: finalMessages,
        isChatLoading: false,
      );
    }
  }

  /// Handles toggle favorites
  Future<void> toggleFavoriteStatus(String query) async {
    await _repository.toggleFavorite(query);
    final favorites = await _repository.getFavorites();
    state = state.copyWith(favorites: favorites);
  }

  /// Reset current search results back to default
  void clearActiveSearch() {
    state = state.copyWith(currentResult: null, error: null);
  }
}

/// Provider of the AppSearchController for UI consumption
final searchControllerProvider = StateNotifierProvider<AppSearchController, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return AppSearchController(repository);
});
