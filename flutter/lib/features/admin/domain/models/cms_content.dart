/// CMS Data Models representing in-app content updates managed by admins
class FeaturedApp {
  final String appName;
  final String originalApp;
  final String description;
  final String category;
  final String downloadUrl;

  FeaturedApp({
    required this.appName,
    required this.originalApp,
    required this.description,
    required this.category,
    required this.downloadUrl,
  });

  factory FeaturedApp.fromJson(Map<String, dynamic> json) {
    return FeaturedApp(
      appName: json['appName'] ?? '',
      originalApp: json['originalApp'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      downloadUrl: json['downloadUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'appName': appName,
    'originalApp': originalApp,
    'description': description,
    'category': category,
    'downloadUrl': downloadUrl,
  };
}

class HelpArticle {
  final String id;
  final String title;
  final String content;
  final String category;

  HelpArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });

  factory HelpArticle.fromJson(Map<String, dynamic> json) {
    return HelpArticle(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
  };
}
