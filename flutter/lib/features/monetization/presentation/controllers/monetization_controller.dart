import 'package:flutter/foundation.dart';
import '../../domain/models/membership_details.dart';
import '../../domain/repositories/monetization_repository.dart';
import '../../../../core/services/ad_service.dart';

class MonetizationController extends ChangeNotifier {
  final MonetizationRepository _repository;
  final AdService _adService = AdService();

  MembershipProfile? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  MembershipProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MonetizationController(this._repository);

  /// Load membership info for current user
  Future<void> fetchProfile(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.getMembershipProfile(userId);
      if (_profile != null && _profile!.hasAdsEnabled) {
        await _adService.initializeAdMob();
      }
    } catch (e) {
      _errorMessage = 'Failed to load membership profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upgrade/Buy Monthly Subscription for ₹99 via Razorpay
  Future<bool> purchasePremium(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.startSubscription(
        userId: userId,
        planId: 'premium_monthly_99',
        amount: 99.0,
      );
      _profile = updated;
      return true;
    } catch (e) {
      _errorMessage = 'Payment or subscription setup failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cancel active premium membership
  Future<bool> cancelActiveSubscription(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.cancelSubscription(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Cancellation failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore previous subscription purchase
  Future<bool> restoreSubscription(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.restorePurchase(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to restore purchases: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Track daily AI usage, checking against limits for non-premium accounts
  Future<bool> checkAndIncrementAiUsage(String userId, {int freeDailyLimit = 5}) async {
    if (_profile == null) {
      await fetchProfile(userId);
    }

    if (_profile!.hasPremiumAccess) {
      // Unlimited AI Searches
      await _repository.recordAiUsage(userId);
      await fetchProfile(userId);
      return true;
    }

    if (_profile!.aiSearchDailyUsage >= freeDailyLimit) {
      _errorMessage = 'Daily free limit of $freeDailyLimit searches reached. Please upgrade to Premium.';
      notifyListeners();
      return false;
    }

    // Still within limits
    await _repository.recordAiUsage(userId);
    _profile = await _repository.getMembershipProfile(userId);
    notifyListeners();
    return true;
  }

  /// Reset counter for daily searches (nightly scheduler trigger helper)
  Future<void> resetUsageCounter(String userId) async {
    _profile = await _repository.resetDailyUsage(userId);
    notifyListeners();
  }

  /// Clear active error state
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
