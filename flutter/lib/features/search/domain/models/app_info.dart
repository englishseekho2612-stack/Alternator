/// Represents search result data returned by the Sanvi Search Engine.
class AppInfo {
  final String name;
  final String developer;
  final String category;
  final String officialWebsite;
  final List<String> supportedPlatforms;
  final String officialDownloadLink;
  final String pricing;
  final bool hasFreeVersion;
  final bool hasOfficialTrial;
  final String systemRequirements;
  final List<String> topFeatures;
  final List<String> pros;
  final List<String> cons;
  final List<AppAlternative> similarApplications;
  final List<AppAlternative> openSourceAlternatives;
  final double? communityRating;
  final String? lastUpdated;

  AppInfo({
    required this.name,
    required this.developer,
    required this.category,
    required this.officialWebsite,
    required this.supportedPlatforms,
    required this.officialDownloadLink,
    required this.pricing,
    required this.hasFreeVersion,
    required this.hasOfficialTrial,
    required this.systemRequirements,
    required this.topFeatures,
    required this.pros,
    required this.cons,
    required this.similarApplications,
    required this.openSourceAlternatives,
    this.communityRating,
    this.lastUpdated,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      name: json['name'] ?? '',
      developer: json['developer'] ?? '',
      category: json['category'] ?? '',
      officialWebsite: json['officialWebsite'] ?? '',
      supportedPlatforms: List<String>.from(json['supportedPlatforms'] ?? []),
      officialDownloadLink: json['officialDownloadLink'] ?? '',
      pricing: json['pricing'] ?? '',
      hasFreeVersion: json['hasFreeVersion'] ?? false,
      hasOfficialTrial: json['hasOfficialTrial'] ?? false,
      systemRequirements: json['systemRequirements'] ?? '',
      topFeatures: List<String>.from(json['topFeatures'] ?? []),
      pros: List<String>.from(json['pros'] ?? []),
      cons: List<String>.from(json['cons'] ?? []),
      similarApplications: (json['similarApplications'] as List?)
              ?.map((x) => AppAlternative.fromJson(x))
              .toList() ?? [],
      openSourceAlternatives: (json['openSourceAlternatives'] as List?)
              ?.map((x) => AppAlternative.fromJson(x))
              .toList() ?? [],
      communityRating: (json['communityRating'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'developer': developer,
      'category': category,
      'officialWebsite': officialWebsite,
      'supportedPlatforms': supportedPlatforms,
      'officialDownloadLink': officialDownloadLink,
      'pricing': pricing,
      'hasFreeVersion': hasFreeVersion,
      'hasOfficialTrial': hasOfficialTrial,
      'systemRequirements': systemRequirements,
      'topFeatures': topFeatures,
      'pros': pros,
      'cons': cons,
      'similarApplications': similarApplications.map((x) => x.toJson()).toList(),
      'openSourceAlternatives': openSourceAlternatives.map((x) => x.toJson()).toList(),
      'communityRating': communityRating,
      'lastUpdated': lastUpdated,
    };
  }
}

/// Represents a similar or open source alternative in the search results
class AppAlternative {
  final String name;
  final String category;
  final String url;
  final String pricing;
  final bool isOpenSource;

  AppAlternative({
    required this.name,
    required this.category,
    required this.url,
    required this.pricing,
    required this.isOpenSource,
  });

  factory AppAlternative.fromJson(Map<String, dynamic> json) {
    return AppAlternative(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      url: json['url'] ?? '',
      pricing: json['pricing'] ?? '',
      isOpenSource: json['isOpenSource'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'url': url,
      'pricing': pricing,
      'isOpenSource': isOpenSource,
    };
  }
}
