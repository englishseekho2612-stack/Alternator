import 'dart:async';
import 'dart:math';
import '../../domain/models/membership_details.dart';
import '../../domain/repositories/monetization_repository.dart';

class MonetizationRepositoryImpl implements MonetizationRepository {
  // In-memory simulated cache of active memberships (key: userId)
  final Map<String, MembershipProfile> _cache = {};

  MembershipProfile _getOrCreateDefault(String userId) {
    if (!_cache.containsKey(userId)) {
      final now = DateTime.now();
      _cache[userId] = MembershipProfile(
        userId: userId,
        tier: MembershipTier.trial, // 3-day Free Trial starts automatically
        trial: TrialInfo(
          startedAt: now,
          expiresAt: now.add(const Duration(days: 3)),
          isActive: true,
        ),
        invoices: [],
        aiSearchDailyUsage: 0,
        isAdPreferred: true,
      );
    }
    return _cache[userId]!;
  }

  @override
  Future<MembershipProfile> getMembershipProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate networking
    return _getOrCreateDefault(userId);
  }

  @override
  Future<MembershipProfile> startSubscription({
    required String userId,
    required String planId,
    required double amount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate payment gateway loading
    
    // Simulate Razorpay transaction validation
    final String paymentId = 'pay_${_generateRandomString(14)}';
    final now = DateTime.now();
    
    final current = _getOrCreateDefault(userId);
    final invoice = InvoiceInfo(
      transactionId: paymentId,
      amount: amount,
      status: 'success',
      date: now,
      paymentMethod: 'razorpay',
    );

    final updated = MembershipProfile(
      userId: userId,
      tier: MembershipTier.premium,
      trial: current.trial,
      activeSubscription: SubscriptionInfo(
        id: 'sub_${_generateRandomString(14)}',
        planId: planId,
        status: 'active',
        amount: amount,
        currentPeriodStart: now,
        currentPeriodEnd: now.add(const Duration(days: 30)),
        cancelAtPeriodEnd: false,
      ),
      invoices: [...current.invoices, invoice],
      aiSearchDailyUsage: current.aiSearchDailyUsage,
      isAdPreferred: false,
    );

    _cache[userId] = updated;
    return updated;
  }

  @override
  Future<MembershipProfile> cancelSubscription(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final current = _getOrCreateDefault(userId);
    if (current.activeSubscription == null) return current;

    final updatedSub = SubscriptionInfo(
      id: current.activeSubscription!.id,
      planId: current.activeSubscription!.planId,
      status: 'cancelled',
      amount: current.activeSubscription!.amount,
      currentPeriodStart: current.activeSubscription!.currentPeriodStart,
      currentPeriodEnd: current.activeSubscription!.currentPeriodEnd,
      cancelAtPeriodEnd: true,
    );

    final updated = MembershipProfile(
      userId: userId,
      tier: MembershipTier.free, // Switch back once period concludes (or immediately for simplicity)
      trial: current.trial,
      activeSubscription: updatedSub,
      invoices: current.invoices,
      aiSearchDailyUsage: current.aiSearchDailyUsage,
      isAdPreferred: true,
    );

    _cache[userId] = updated;
    return updated;
  }

  @override
  Future<MembershipProfile> restorePurchase(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final current = _getOrCreateDefault(userId);
    
    // Simulated remote recovery for previously subscribed accounts
    final now = DateTime.now();
    final restoredInvoice = InvoiceInfo(
      transactionId: 'pay_restored_199',
      amount: 199.0,
      status: 'success',
      date: now.subtract(const Duration(days: 5)),
      paymentMethod: 'razorpay',
    );

    final restored = MembershipProfile(
      userId: userId,
      tier: MembershipTier.premium,
      trial: current.trial,
      activeSubscription: SubscriptionInfo(
        id: 'sub_restored_99',
        planId: 'premium_monthly_199',
        status: 'active',
        amount: 199.0,
        currentPeriodStart: now.subtract(const Duration(days: 5)),
        currentPeriodEnd: now.add(const Duration(days: 25)),
        cancelAtPeriodEnd: false,
      ),
      invoices: [...current.invoices, restoredInvoice],
      aiSearchDailyUsage: current.aiSearchDailyUsage,
      isAdPreferred: false,
    );

    _cache[userId] = restored;
    return restored;
  }

  @override
  Future<MembershipProfile> recordAiUsage(String userId) async {
    final current = _getOrCreateDefault(userId);
    final updated = MembershipProfile(
      userId: userId,
      tier: current.tier,
      trial: current.trial,
      activeSubscription: current.activeSubscription,
      invoices: current.invoices,
      aiSearchDailyUsage: current.aiSearchDailyUsage + 1,
      isAdPreferred: current.isAdPreferred,
    );
    _cache[userId] = updated;
    return updated;
  }

  @override
  Future<MembershipProfile> resetDailyUsage(String userId) async {
    final current = _getOrCreateDefault(userId);
    final updated = MembershipProfile(
      userId: userId,
      tier: current.tier,
      trial: current.trial,
      activeSubscription: current.activeSubscription,
      invoices: current.invoices,
      aiSearchDailyUsage: 0,
      isAdPreferred: current.isAdPreferred,
    );
    _cache[userId] = updated;
    return updated;
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
  }
}
