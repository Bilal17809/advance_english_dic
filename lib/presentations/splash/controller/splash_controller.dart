import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../subscription/subscription_view.dart';
import '../../home/view/home_page.dart';

class SplashController extends GetxController {
  // final  removeAds = Get.find<RemoveAds>();
  // final  splashAd = Get.find<SplashInterstitialAdController>();

  var showProgress = true.obs;
  var progressValue = 0.0.obs;
  var isFinished = false.obs;

  @override
  void onInit() {
    super.onInit();
    // splashAd.loadInterstitialAd();
    startProgressBar();
  }

  void startProgressBar() {
    const duration = Duration(milliseconds: 100);
    double step = 1 / (4000 / 100);

    Timer.periodic(duration, (timer) {
      progressValue.value += step;

      if (progressValue.value >= 1.0) {
        timer.cancel();
        showProgress.value = false;
      }
    });
  }

  void startSwipeProcess() {
    Future.delayed(const Duration(seconds: 5), () {
      isFinished.value = true;
    });
  }

  Future<void> onSwipeFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeen = prefs.getBool("hasSeen") ?? false;

    if (!hasSeen) {
      await Future.delayed(const Duration(milliseconds: 100));
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => Subscriptions(),
      );
      prefs.setBool("hasSeen", true);
    }

    // if (!removeAds.isSubscribedGet.value) {
    //   if (splashAd.isAdReady.value) {
    //     await splashAd.showInterstitialAd();
    //   }
    // }

    Get.off(() => HomePage());
    isFinished.value = false;
  }
}
