import '../models/app_info.dart';
import '../models/search_history_item.dart';

/// Abstract Search Repository defining contract for AI Search & History operations.
abstract class SearchRepository {
  /// Queries Sanvi AI to search for application details and legal alternatives
  Future<AppInfo> searchApplication(String query);

  /// Submits general chat questions to Sanvi (supports Hindi, English, Hinglish)
  Future<String> chatWithSanvi(String query, List<Map<String, String>> chatHistory);

  /// Retrieves search history (Architectural preparation)
  Future<List<SearchHistoryItem>> getSearchHistory();

  /// Saves search history item (Architectural preparation)
  Future<void> saveSearchQuery(String query);

  /// Adds or removes an application/query to favorites (Architectural preparation)
  Future<void> toggleFavorite(String query);

  /// Retrieves all favorited search results (Architectural preparation)
  Future<List<SearchHistoryItem>> getFavorites();
}
