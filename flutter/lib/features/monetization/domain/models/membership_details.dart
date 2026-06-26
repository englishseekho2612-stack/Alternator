/// Membership tier representing active subscriptions
enum MembershipTier { free, trial, premium }

/// Detailed Subscription model containing active metadata
class SubscriptionInfo {
  final String id;
  final String planId;
  final String status; // active, cancelled, expired, pending
  final double amount;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  SubscriptionInfo({
    required this.id,
    required this.planId,
    required this.status,
    required this.amount,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      id: json['id'] ?? '',
      planId: json['planId'] ?? 'premium_monthly_199',
      status: json['status'] ?? 'pending',
      amount: (json['amount'] as num?)?.toDouble() ?? 199.0,
      currentPeriodStart: DateTime.parse(json['currentPeriodStart'] ?? DateTime.now().toIso8601String()),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] ?? DateTime.now().add(const Duration(days: 30)).toIso8601String()),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'planId': planId,
    'status': status,
    'amount': amount,
    'currentPeriodStart': currentPeriodStart.toIso8601String(),
    'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
    'cancelAtPeriodEnd': cancelAtPeriodEnd,
  };
}

/// Trial details tracking for legal free trial periods
class TrialInfo {
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool isActive;

  TrialInfo({
    required this.startedAt,
    required this.expiresAt,
    required this.isActive,
  });

  int get remainingDays {
    final diff = expiresAt.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  factory TrialInfo.fromJson(Map<String, dynamic> json) {
    return TrialInfo(
      startedAt: DateTime.parse(json['startedAt'] ?? DateTime.now().toIso8601String()),
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().add(const Duration(days: 3)).toIso8601String()),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'startedAt': startedAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
    'isActive': isActive,
  };
}

/// Model for processed transactions or invoices via Razorpay
class InvoiceInfo {
  final String transactionId;
  final double amount;
  final String status;
  final DateTime date;
  final String paymentMethod;

  InvoiceInfo({
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.date,
    required this.paymentMethod,
  });

  factory InvoiceInfo.fromJson(Map<String, dynamic> json) {
    return InvoiceInfo(
      transactionId: json['transactionId'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'success',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      paymentMethod: json['paymentMethod'] ?? 'razorpay',
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'amount': amount,
    'status': status,
    'date': date.toIso8601String(),
    'paymentMethod': paymentMethod,
  };
}

/// Consolidated Membership profile for secure access verification
class MembershipProfile {
  final String userId;
  final MembershipTier tier;
  final TrialInfo trial;
  final SubscriptionInfo? activeSubscription;
  final List<InvoiceInfo> invoices;
  final int aiSearchDailyUsage; // Tracker for free limits
  final bool isAdPreferred;

  MembershipProfile({
    required this.userId,
    required this.tier,
    required this.trial,
    this.activeSubscription,
    required this.invoices,
    this.aiSearchDailyUsage = 0,
    this.isAdPreferred = true,
  });

  bool get hasPremiumAccess => tier == MembershipTier.premium || (tier == MembershipTier.trial && trial.remainingDays > 0);
  bool get hasAdsEnabled => !hasPremiumAccess && isAdPreferred;

  factory MembershipProfile.fromJson(Map<String, dynamic> json) {
    return MembershipProfile(
      userId: json['userId'] ?? 'anon_user',
      tier: MembershipTier.values.firstWhere(
        (e) => e.name == (json['tier'] ?? 'free'),
        orElse: () => MembershipTier.free,
      ),
      trial: TrialInfo.fromJson(json['trial'] ?? {}),
      activeSubscription: json['activeSubscription'] != null 
          ? SubscriptionInfo.fromJson(json['activeSubscription']) 
          : null,
      invoices: (json['invoices'] as List?)?.map((x) => InvoiceInfo.fromJson(x)).toList() ?? [],
      aiSearchDailyUsage: json['aiSearchDailyUsage'] ?? 0,
      isAdPreferred: json['isAdPreferred'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'tier': tier.name,
    'trial': trial.toJson(),
    'activeSubscription': activeSubscription?.toJson(),
    'invoices': invoices.map((x) => x.toJson()).toList(),
    'aiSearchDailyUsage': aiSearchDailyUsage,
    'isAdPreferred': isAdPreferred,
  };
}
