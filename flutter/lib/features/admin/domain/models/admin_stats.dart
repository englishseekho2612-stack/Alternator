/// Roles representing backend authority constraints
enum AdminRole { superAdmin, admin, moderator, support, viewer }

/// Analytics payload tracing business-critical conversions
class RevenueStats {
  final double totalRevenue;
  final double adRevenue;
  final double premiumSubscriptionRevenue;
  final double trialConversionRate; // e.g. 0.42 (42%)

  RevenueStats({
    required this.totalRevenue,
    required this.adRevenue,
    required this.premiumSubscriptionRevenue,
    required this.trialConversionRate,
  });

  factory RevenueStats.fromJson(Map<String, dynamic> json) {
    return RevenueStats(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      adRevenue: (json['adRevenue'] as num?)?.toDouble() ?? 0.0,
      premiumSubscriptionRevenue: (json['premiumSubscriptionRevenue'] as num?)?.toDouble() ?? 0.0,
      trialConversionRate: (json['trialConversionRate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'adRevenue': adRevenue,
    'premiumSubscriptionRevenue': premiumSubscriptionRevenue,
    'trialConversionRate': trialConversionRate,
  };
}

/// Admin Dashboard metrics payload
class AdminStats {
  final int totalUsers;
  final int activeUsers;
  final int premiumUsers;
  final int trialUsers;
  final RevenueStats revenue;
  final Map<String, int> searchTrends; // e.g., {'Photoshop': 420, 'Figma': 350}
  final List<String> errorLogs;

  AdminStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.premiumUsers,
    required this.trialUsers,
    required this.revenue,
    required this.searchTrends,
    required this.errorLogs,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['totalUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      premiumUsers: json['premiumUsers'] ?? 0,
      trialUsers: json['trialUsers'] ?? 0,
      revenue: RevenueStats.fromJson(json['revenue'] ?? {}),
      searchTrends: Map<String, int>.from(json['searchTrends'] ?? {}),
      errorLogs: List<String>.from(json['errorLogs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalUsers': totalUsers,
    'activeUsers': activeUsers,
    'premiumUsers': premiumUsers,
    'trialUsers': trialUsers,
    'revenue': revenue.toJson(),
    'searchTrends': searchTrends,
    'errorLogs': errorLogs,
  };
}
