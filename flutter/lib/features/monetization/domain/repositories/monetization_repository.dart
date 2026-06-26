import '../models/membership_details.dart';

abstract class MonetizationRepository {
  /// Fetches membership details for active user
  Future<MembershipProfile> getMembershipProfile(String userId);

  /// Initiates premium checkout process via Razorpay
  Future<MembershipProfile> startSubscription({
    required String userId,
    required String planId,
    required double amount,
  });

  /// Cancels active user premium subscription
  Future<MembershipProfile> cancelSubscription(String userId);

  /// Restores active user previous purchase history
  Future<MembershipProfile> restorePurchase(String userId);

  /// Increments daily AI usage and returns updated profile
  Future<MembershipProfile> recordAiUsage(String userId);

  /// Reset usage counters (simulated scheduled task)
  Future<MembershipProfile> resetDailyUsage(String userId);
}
