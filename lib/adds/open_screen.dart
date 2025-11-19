import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';
// class AppOpenAdController extends GetxController with WidgetsBindingObserver {
//   final RemoveAds removeAds = Get.put(RemoveAds());
//
//   final RxBool isShowingOpenAd = false.obs;
//
//   AppOpenAd? _appOpenAd;
//   bool _isAdAvailable = false;
//   bool shouldShowAppOpenAd = true;
//   bool _isFromBackground = false;
//   bool isCooldownActive = false;
//   bool _interstitialAdDismissed = false;
//   bool _openAppAdEligible = false;
//   bool isAppResumed = false;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       print("App moved to background.");
//       _openAppAdEligible = true;
//     } else if (state == AppLifecycleState.resumed) {
//       print("App moved to foreground.");
//
//       Future.delayed(const Duration(milliseconds: 100), () {
//         if (_openAppAdEligible && !_interstitialAdDismissed) {
//           showAdIfAvailable();
//         } else {
//           print("Skipping Open App Ad (flags not met).");
//         }
//         _openAppAdEligible = false; // Reset regardless
//         _interstitialAdDismissed = false; // Reset regardless
//       });
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//     initializeRemoteConfig();
//   }
//
//   Future<void> initializeRemoteConfig() async {
//     final remoteConfig = FirebaseRemoteConfig.instance;
//     try {
//       await remoteConfig.fetchAndActivate();
//       shouldShowAppOpenAd = remoteConfig.getBool('AppOpenAd');
//       print('Remote Config: appOpen = $shouldShowAppOpenAd');
//       loadAd();
//     } catch (e) {
//       print('Error fetching Remote Config: $e');
//     }
//   }
//
//   void showAdIfAvailable() {
//     if (removeAds.isSubscribedGet.value) {
//       return;
//     } else if (_isAdAvailable && _appOpenAd != null && !isCooldownActive) {
//       _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdShowedFullScreenContent: (ad) {
//           print('App Open Ad is showing.');
//           isShowingOpenAd.value = true;
//         },
//         onAdDismissedFullScreenContent: (ad) {
//           print('App Open Ad dismissed.');
//           _appOpenAd = null;
//           _isAdAvailable = false;
//           isShowingOpenAd.value = false;
//           loadAd();
//           activateCooldown();
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           print('Failed to show App Open Ad: $error');
//           _appOpenAd = null;
//           _isAdAvailable = false;
//           isShowingOpenAd.value = false;
//           loadAd();
//         },
//       );
//
//       _appOpenAd!.show();
//       _appOpenAd = null;
//       _isAdAvailable = false;
//     } else {
//       print('No App Open Ad available to show.');
//       loadAd();
//     }
//   }
//
//   void activateCooldown() {
//     isCooldownActive = true;
//     Future.delayed(const Duration(seconds: 5), () {
//       isCooldownActive = false;
//     });
//   }
//
//   void loadAd() {
//     if (!shouldShowAppOpenAd) return;
//
//     AppOpenAd.load(
//       adUnitId: 'ca-app-pub-5405847310750111/7111246057',
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           _appOpenAd = ad;
//           _isAdAvailable = true;
//           print('App Open Ad loaded.');
//         },
//         onAdFailedToLoad: (error) {
//           print('Failed to load App Open Ad: $error');
//           _isAdAvailable = false;
//         },
//       ),
//     );
//   }
//
//   void setInterstitialAdDismissed() {
//     _interstitialAdDismissed = true;
//     print("Interstitial Ad dismissed, flag set.");
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _appOpenAd?.dispose();
//     super.onClose();
//   }
// }


class AppOpenAdController extends GetxController with WidgetsBindingObserver {
  final RemoveAds removeAds = Get.put(RemoveAds());

  final RxBool isShowingOpenAd = false.obs;

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool shouldShowAppOpenAd = true;
  bool _isFromBackground = false;
  bool isCooldownActive = false;
  bool _interstitialAdDismissed = false;
  bool _openAppAdEligible = false;
  bool isAppResumed = false;
  bool _isSplashInterstitialShown = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("App moved to background.");
      _openAppAdEligible = true;
    } else if (state == AppLifecycleState.resumed) {
      print("App moved to foreground.");

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_openAppAdEligible && !_interstitialAdDismissed) {
          showAdIfAvailable();
        } else {
          print("Skipping Open App Ad (flags not met).");
        }
        _openAppAdEligible = false; // Reset regardless
        _interstitialAdDismissed = false; // Reset regardless
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
          print('App Open Ad is showing.');
          isShowingOpenAd.value = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          print('App Open Ad dismissed.');
          _appOpenAd = null;
          _isAdAvailable = false;
          isShowingOpenAd.value = false;
          loadAd();
          activateCooldown();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show App Open Ad: $error');
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
          print('App Open Ad loaded.');
        },
        onAdFailedToLoad: (error) {
          print('Failed to load App Open Ad: $error');
          _isAdAvailable = false;
        },
      ),
    );
  }
  void setInterstitialAdDismissed() {
    _interstitialAdDismissed = true;
    print("Interstitial Ad dismissed, flag set.");
  }

  void setSplashInterstitialFlag(bool shown) {
    _isSplashInterstitialShown = shown;
  }

  void maybeShowAppOpenAd() {
    if (_isSplashInterstitialShown) {
      print("### Skipping AppOpenAd due to splash interstitial.");
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