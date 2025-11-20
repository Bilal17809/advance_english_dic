import 'dart:async';
import 'dart:ui';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';
import 'open_screen.dart';

class InterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  bool isAdReadyFor = false;
  int screenVisitCount = 0;
  int adTriggerCount = 3;
  var isAdReady = false.obs;
  final removeAds = Get.find<RemoveAds>();

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadInterstitialAd();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();

      if (remoteConfig.getValue('InterstitialAd').source != ValueSource.valueStatic) {
        adTriggerCount = remoteConfig.getInt('InterstitialAd');
        print("### Remote Config: Ad Trigger Count = $adTriggerCount");
      } else {
        print("### Remote Config: Using default value.");
      }
      update();
    } catch (e) {
      print('Error fetching Remote Config: $e');
      adTriggerCount = 3;
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:'ca-app-pub-5405847310750111/5765405722',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReadyFor = true;
          update();
        },
        onAdFailedToLoad: (error) {
          isAdReadyFor = false;
        },
      ),
    );
  }


  void showInterstitialAd() {
    if(removeAds.isSubscribedGet.value){
      return;
    }
    if (_interstitialAd != null && isAdReadyFor) {
      isAdReady.value = true;

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          isAdReady.value = false;
          ad.dispose();
          isAdReadyFor = false;
          screenVisitCount = 0;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          isAdReady.value = false;
          ad.dispose();
          isAdReadyFor = false;
          loadInterstitialAd();
          update();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
  }
  void checkAndShowAd() {
    screenVisitCount++;
    if (screenVisitCount >= adTriggerCount) {
      if (isAdReadyFor) {
        showInterstitialAd();
      } else {
        print("### Interstitial Ad not ready yet.");
        screenVisitCount = 0;
      }
    }
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}


//>>>>>>>>>>>>>>>>>
class SplashInterstitialAdController extends GetxController {
  InterstitialAd? _interstitialAd;
  var isAdReady = false.obs;
  bool showSplashAd = false;

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
    loadInterstitialAd();
  }

  Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await remoteConfig.fetchAndActivate();

      showSplashAd = remoteConfig.getBool('SplashInterstitialAd');
      update();
    } catch (e) {
      showSplashAd = false;
    }
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-5405847310750111/1066831740',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          isAdReady.value = true;
          update();
        },
        onAdFailedToLoad: (error) {
          isAdReady.value= false;
        },
      ),
    );
  }


  Future<void> showInterstitialAdUser({VoidCallback? onAdComplete}) async {
    if (!showSplashAd || _interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        Get.find<AppOpenAdController>().setInterstitialAdDismissed();
        ad.dispose();
        isAdReady.value = false;
        loadInterstitialAd();
        onAdComplete?.call();
        update();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        isAdReady.value = false;
        loadInterstitialAd();
        onAdComplete?.call();
        update();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<void> showInterstitialAd() async{
    if (!showSplashAd) {
      return;
    }
    if (_interstitialAd != null) {

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          Get.find<AppOpenAdController>().setInterstitialAdDismissed();
          ad.dispose();
          isAdReady.value = false;
          loadInterstitialAd();
          update();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          isAdReady.value = false;
          loadInterstitialAd();
          update();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("### Interstitial Ad not ready.");
    }
    adCompleted.value = true;
  }
  var adCompleted = false.obs;
  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}
