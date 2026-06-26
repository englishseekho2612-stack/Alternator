import 'dart:async';
import '../../features/monetization/domain/models/membership_details.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _initialized = false;
  bool _bannerAdLoaded = false;
  bool _interstitialAdLoaded = false;

  bool get isBannerAdLoaded => _bannerAdLoaded;
  bool get isInterstitialAdLoaded => _interstitialAdLoaded;

  Future<void> initializeAdMob() async {
    if (_initialized) return;
    print('AdMob: Initializing Google Mobile Ads SDK...');
    await Future.delayed(const Duration(milliseconds: 500));
    _initialized = true;
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    print('AdMob: Loading Banner Ad unit ca-app-pub-3940256099942544/6300978111');
    _bannerAdLoaded = true;
  }

  void _loadInterstitialAd() {
    print('AdMob: Loading Interstitial Ad unit ca-app-pub-3940256099942544/1033173712');
    _interstitialAdLoaded = true;
  }

  /// Safely shows banner ad if user does not have premium or trial access active
  bool shouldShowBannerAd(MembershipProfile? profile) {
    if (profile == null) return true;
    return profile.hasAdsEnabled;
  }

  /// Trigger showing Interstitial Ad before critical actions (e.g. search, view alternatives)
  Future<void> showInterstitialAdIfEligible(MembershipProfile? profile, {required Function onAdDismissed}) async {
    if (profile != null && !profile.hasAdsEnabled) {
      print('AdMob: User has active Premium/Trial membership. Skipping interstitial ad.');
      onAdDismissed();
      return;
    }

    if (!_interstitialAdLoaded) {
      print('AdMob: Interstitial ad not fully loaded. Retrying load...');
      _loadInterstitialAd();
      onAdDismissed();
      return;
    }

    print('AdMob: Displaying Interstitial Ad...');
    await Future.delayed(const Duration(seconds: 1)); // Simulate ad presentation overlay duration
    print('AdMob: Interstitial Ad dismissed.');
    _interstitialAdLoaded = false; // reset state
    _loadInterstitialAd(); // preload next
    onAdDismissed();
  }
}
