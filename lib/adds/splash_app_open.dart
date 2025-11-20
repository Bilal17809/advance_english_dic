import 'dart:async';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class SplashAppOpenAds extends GetxController {
  AppOpenAd? _appOpenAd;
  var isAdReady = false.obs;
  bool showSplashAd = false;
  final removeAds = Get.find<RemoveAds>();

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadAppOpenAd();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      await remoteConfig.fetchAndActivate();
      showSplashAd = remoteConfig.getBool('SplashAppOpenAd');
      update();
    } catch (e) {
      showSplashAd = false;
    }
  }

  void loadAppOpenAd() {
    if (!showSplashAd || removeAds.isSubscribedGet.value) return;
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-5405847310750111/8890233096',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isAdReady.value = true;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isAdReady.value = false;
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              isAdReady.value = false;
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          isAdReady.value = false;
        },
      ),
    );
  }

  /// Shows App Open Ad on Splash if ready
  Future<void> showAppOpenAd() async {
    if (_appOpenAd != null && isAdReady.value) {
      _appOpenAd!.show();
      _appOpenAd = null;
      isAdReady.value = false;
    } else {
      print("Splash App Open Ad not ready.");
    }
  }

  @override
  void onClose() {
    _appOpenAd?.dispose();
    super.onClose();
  }
}
