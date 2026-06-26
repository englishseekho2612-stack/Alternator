/// Represents a item in the user's search history.
/// Contains search terms, search timestamp, and whether it was favorited.
class SearchHistoryItem {
  final String query;
  final DateTime timestamp;
  final bool isFavorite;

  SearchHistoryItem({
    required this.query,
    required this.timestamp,
    this.isFavorite = false,
  });

  SearchHistoryItem copyWith({
    String? query,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return SearchHistoryItem(
      query: query ?? this.query,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      query: json['query'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }
}
