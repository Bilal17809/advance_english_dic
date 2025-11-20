import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class AppOpenAdController extends GetxController with WidgetsBindingObserver {
  final RemoveAds removeAds = Get.put(RemoveAds());

  final RxBool isShowingOpenAd = false.obs;

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool shouldShowAppOpenAd = true;
  bool isCooldownActive = false;
  bool _interstitialAdDismissed = false;
  bool _openAppAdEligible = false;
  bool isAppResumed = false;
  bool _isSplashInterstitialShown = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _openAppAdEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_openAppAdEligible && !_interstitialAdDismissed) {
          showAdIfAvailable();
        } else {
          print("Skipping Open App Ad (flags not met).");
        }
        _openAppAdEligible = false;
        _interstitialAdDismissed = false;
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.fetchAndActivate();
      shouldShowAppOpenAd = remoteConfig.getBool('AppOpenAd');
      print('Remote Config: appOpen = $shouldShowAppOpenAd');
      loadAd();
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  void showAdIfAvailable() {
    if (removeAds.isSubscribedGet.value) {
      return;
    } else if (_isAdAvailable && _appOpenAd != null && !isCooldownActive) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          isShowingOpenAd.value = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
        },
      );

      _appOpenAd!.show();
      _appOpenAd = null;
      _isAdAvailable = false;
    } else {
      print('No App Open Ad available to show.');
      loadAd();
    }
  }

  void activateCooldown() {
    isCooldownActive = true;
    Future.delayed(const Duration(seconds: 5), () {
      isCooldownActive = false;
    });
  }

  void loadAd() {
    if (!shouldShowAppOpenAd) return;

    AppOpenAd.load(
      adUnitId: 'ca-app-pub-5405847310750111/7111246057',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
        },
        onAdFailedToLoad: (error) {
          _isAdAvailable = false;
        },
      ),
    );
  }
  void setInterstitialAdDismissed() {
    _interstitialAdDismissed = true;
  }

  void setSplashInterstitialFlag(bool shown) {
    _isSplashInterstitialShown = shown;
  }

  void maybeShowAppOpenAd() {
    if (_isSplashInterstitialShown) {
      return;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
    super.onClose();
  }
}