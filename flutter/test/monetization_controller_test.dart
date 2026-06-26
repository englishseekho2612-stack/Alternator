import 'package:flutter_test/flutter_test.dart';
import 'package:apps_alternator/features/monetization/domain/models/membership_details.dart';
import 'package:apps_alternator/features/monetization/domain/repositories/monetization_repository.dart';
import 'package:apps_alternator/features/monetization/presentation/controllers/monetization_controller.dart';

class MockMonetizationRepository implements MonetizationRepository {
  MembershipProfile? mockProfile;

  MockMonetizationRepository() {
    mockProfile = MembershipProfile(
      userId: 'test_user_007',
      tier: MembershipTier.free,
      trial: TrialInfo(
        startedAt: DateTime.now().subtract(const Duration(days: 4)),
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        isActive: false, // Expired trial
      ),
      invoices: [],
      aiSearchDailyUsage: 2,
      isAdPreferred: true,
    );
  }

  @override
  Future<MembershipProfile> getMembershipProfile(String userId) async {
    return mockProfile!;
  }

  @override
  Future<MembershipProfile> startSubscription({
    required String userId,
    required String planId,
    required double amount,
  }) async {
    mockProfile = MembershipProfile(
      userId: userId,
      tier: MembershipTier.premium,
      trial: mockProfile!.trial,
      activeSubscription: SubscriptionInfo(
        id: 'sub_premium_test',
        planId: planId,
        status: 'active',
        amount: amount,
        currentPeriodStart: DateTime.now(),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 30)),
        cancelAtPeriodEnd: false,
      ),
      invoices: [
        InvoiceInfo(
          transactionId: 'tx_test_123',
          amount: amount,
          status: 'success',
          date: DateTime.now(),
          paymentMethod: 'razorpay',
        )
      ],
      aiSearchDailyUsage: mockProfile!.aiSearchDailyUsage,
      isAdPreferred: false,
    );
    return mockProfile!;
  }

  @override
  Future<MembershipProfile> cancelSubscription(String userId) async {
    mockProfile = MembershipProfile(
      userId: userId,
      tier: MembershipTier.free,
      trial: mockProfile!.trial,
      activeSubscription: null,
      invoices: mockProfile!.invoices,
      aiSearchDailyUsage: mockProfile!.aiSearchDailyUsage,
      isAdPreferred: true,
    );
    return mockProfile!;
  }

  @override
  Future<MembershipProfile> restorePurchase(String userId) async {
    mockProfile = MembershipProfile(
      userId: userId,
      tier: MembershipTier.premium,
      trial: mockProfile!.trial,
      activeSubscription: SubscriptionInfo(
        id: 'sub_restored_test',
        planId: 'premium_monthly_199',
        status: 'active',
        amount: 199.0,
        currentPeriodStart: DateTime.now().subtract(const Duration(days: 1)),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 29)),
        cancelAtPeriodEnd: false,
      ),
      invoices: mockProfile!.invoices,
      aiSearchDailyUsage: mockProfile!.aiSearchDailyUsage,
      isAdPreferred: false,
    );
    return mockProfile!;
  }

  @override
  Future<MembershipProfile> recordAiUsage(String userId) async {
    mockProfile = MembershipProfile(
      userId: userId,
      tier: mockProfile!.tier,
      trial: mockProfile!.trial,
      activeSubscription: mockProfile!.activeSubscription,
      invoices: mockProfile!.invoices,
      aiSearchDailyUsage: mockProfile!.aiSearchDailyUsage + 1,
      isAdPreferred: mockProfile!.isAdPreferred,
    );
    return mockProfile!;
  }

  @override
  Future<MembershipProfile> resetDailyUsage(String userId) async {
    mockProfile = MembershipProfile(
      userId: userId,
      tier: mockProfile!.tier,
      trial: mockProfile!.trial,
      activeSubscription: mockProfile!.activeSubscription,
      invoices: mockProfile!.invoices,
      aiSearchDailyUsage: 0,
      isAdPreferred: mockProfile!.isAdPreferred,
    );
    return mockProfile!;
  }
}

void main() {
  group('MonetizationController & Premium Logic Tests', () {
    late MockMonetizationRepository mockRepo;
    late MonetizationController controller;

    setUp(() {
      mockRepo = MockMonetizationRepository();
      controller = MonetizationController(mockRepo);
    });

    test('Loads initial membership profile and handles loading state properly', () async {
      expect(controller.profile, isNull);
      expect(controller.isLoading, isFalse);

      final fetchFuture = controller.fetchProfile('test_user_007');
      expect(controller.isLoading, isTrue);

      await fetchFuture;
      expect(controller.isLoading, isFalse);
      expect(controller.profile, isNotNull);
      expect(controller.profile!.tier, MembershipTier.free);
      expect(controller.profile!.aiSearchDailyUsage, 2);
    });

    test('Purchase Premium updates active tier and logs transaction successfully', () async {
      await controller.fetchProfile('test_user_007');
      expect(controller.profile!.tier, MembershipTier.free);

      final success = await controller.purchasePremium('test_user_007');
      expect(success, isTrue);
      expect(controller.profile!.tier, MembershipTier.premium);
      expect(controller.profile!.hasPremiumAccess, isTrue);
      expect(controller.profile!.invoices.length, 1);
      expect(controller.profile!.invoices.first.transactionId, 'tx_test_123');
    });

    test('Enforces free search tier limit correctly', () async {
      await controller.fetchProfile('test_user_007');
      expect(controller.profile!.aiSearchDailyUsage, 2);

      // Perform 3rd search (Allowed, limit is 5)
      bool allowed = await controller.checkAndIncrementAiUsage('test_user_007', freeDailyLimit: 5);
      expect(allowed, isTrue);
      expect(controller.profile!.aiSearchDailyUsage, 3);

      // Perform 4th search (Allowed)
      allowed = await controller.checkAndIncrementAiUsage('test_user_007', freeDailyLimit: 5);
      expect(allowed, isTrue);
      expect(controller.profile!.aiSearchDailyUsage, 4);

      // Perform 5th search (Allowed)
      allowed = await controller.checkAndIncrementAiUsage('test_user_007', freeDailyLimit: 5);
      expect(allowed, isTrue);
      expect(controller.profile!.aiSearchDailyUsage, 5);

      // Perform 6th search (Blocked! Daily free limit reached)
      allowed = await controller.checkAndIncrementAiUsage('test_user_007', freeDailyLimit: 5);
      expect(allowed, isFalse);
      expect(controller.profile!.aiSearchDailyUsage, 5);
      expect(controller.errorMessage, contains('Daily free limit of 5 searches reached'));
    });

    test('Premium subscriber is bypasses daily limits with unlimited queries', () async {
      await controller.fetchProfile('test_user_007');
      await controller.purchasePremium('test_user_007');

      // Set usage to 10
      mockRepo.mockProfile = mockRepo.mockProfile!.copyWith(aiSearchDailyUsage: 10);
      await controller.fetchProfile('test_user_007');

      // Allowed because of premium status
      bool allowed = await controller.checkAndIncrementAiUsage('test_user_007', freeDailyLimit: 5);
      expect(allowed, isTrue);
      expect(controller.profile!.aiSearchDailyUsage, 11);
      expect(controller.errorMessage, isNull);
    });

    test('Cancel Subscription updates subscription renewal state correctly', () async {
      await controller.fetchProfile('test_user_007');
      await controller.purchasePremium('test_user_007');
      expect(controller.profile!.tier, MembershipTier.premium);

      final cancelSuccess = await controller.cancelActiveSubscription('test_user_007');
      expect(cancelSuccess, isTrue);
      expect(controller.profile!.tier, MembershipTier.free);
    });

    test('Reset daily usage sets usage counter back to zero successfully', () async {
      await controller.fetchProfile('test_user_007');
      expect(controller.profile!.aiSearchDailyUsage, 2);

      await controller.resetUsageCounter('test_user_007');
      expect(controller.profile!.aiSearchDailyUsage, 0);
    });
  });
}
