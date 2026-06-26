/// Sanvi AI system prompts, guidelines and constraints configuration
class AIConfig {
  final String promptTemplate;
  final int dailyFreeUsageLimit;
  final bool safetyFiltersEnabled;
  final String currentPersonality; // professional, conversational, custom hinglish
  final List<String> supportedLanguages;

  AIConfig({
    required this.promptTemplate,
    required this.dailyFreeUsageLimit,
    required this.safetyFiltersEnabled,
    required this.currentPersonality,
    required this.supportedLanguages,
  });

  AIConfig copyWith({
    String? promptTemplate,
    int? dailyFreeUsageLimit,
    bool? safetyFiltersEnabled,
    String? currentPersonality,
    List<String>? supportedLanguages,
  }) {
    return AIConfig(
      promptTemplate: promptTemplate ?? this.promptTemplate,
      dailyFreeUsageLimit: dailyFreeUsageLimit ?? this.dailyFreeUsageLimit,
      safetyFiltersEnabled: safetyFiltersEnabled ?? this.safetyFiltersEnabled,
      currentPersonality: currentPersonality ?? this.currentPersonality,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
    );
  }

  factory AIConfig.fromJson(Map<String, dynamic> json) {
    return AIConfig(
      promptTemplate: json['promptTemplate'] ?? 'You are Sanvi, a warm expert companion designed to suggest great open source and local software alternatives.',
      dailyFreeUsageLimit: json['dailyFreeUsageLimit'] ?? 3,
      safetyFiltersEnabled: json['safetyFiltersEnabled'] ?? true,
      currentPersonality: json['currentPersonality'] ?? 'conversational',
      supportedLanguages: List<String>.from(json['supportedLanguages'] ?? ['en', 'hi', 'hinglish']),
    );
  }

  Map<String, dynamic> toJson() => {
    'promptTemplate': promptTemplate,
    'dailyFreeUsageLimit': dailyFreeUsageLimit,
    'safetyFiltersEnabled': safetyFiltersEnabled,
    'currentPersonality': currentPersonality,
    'supportedLanguages': supportedLanguages,
  };
}
