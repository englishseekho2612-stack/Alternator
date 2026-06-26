/// Represents a saved application in the user's favorites
class FavoriteItem {
  final String appName;
  final String originalApp;
  final String category;
  final DateTime favoritedAt;
  final String alternativeType; // open_source, commercial

  FavoriteItem({
    required this.appName,
    required this.originalApp,
    required this.category,
    required this.favoritedAt,
    this.alternativeType = 'open_source',
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      appName: json['appName'] ?? '',
      originalApp: json['originalApp'] ?? '',
      category: json['category'] ?? '',
      favoritedAt: DateTime.parse(json['favoritedAt'] ?? DateTime.now().toIso8601String()),
      alternativeType: json['alternativeType'] ?? 'open_source',
    );
  }

  Map<String, dynamic> toJson() => {
    'appName': appName,
    'originalApp': originalApp,
    'category': category,
    'favoritedAt': favoritedAt.toIso8601String(),
    'alternativeType': alternativeType,
  };
}
