/// Metatada representation of a saved Sanvi chat conversation for quick resume/cloud sync
class ConversationMetadata {
  final String id;
  final String title;
  final DateTime lastUpdatedAt;
  final int messageCount;

  ConversationMetadata({
    required this.id,
    required this.title,
    required this.lastUpdatedAt,
    required this.messageCount,
  });

  factory ConversationMetadata.fromJson(Map<String, dynamic> json) {
    return ConversationMetadata(
      id: json['id'] ?? '',
      title: json['title'] ?? 'New Chat Session',
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] ?? DateTime.now().toIso8601String()),
      messageCount: json['messageCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'lastUpdatedAt': lastUpdatedAt.toIso8601String(),
    'messageCount': messageCount,
  };
}
