import 'package:electricity_app/adds/instertial_adds.dart';
import 'package:electricity_app/adds/open_screen.dart';
import 'package:electricity_app/presentations/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../../adds/native_adss.dart';
import '../../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class DependencyInject{
  static void init() {
    // ads injections
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);

    Get.lazyPut<AppOpenAdController>(() => AppOpenAdController(), fenix: true);
    Get.lazyPut<InterstitialAdController>(() => InterstitialAdController(),
        fenix: true);
    Get.lazyPut<NativeAdController>(() => NativeAdController(), fenix: true);
    Get.lazyPut<SplashInterstitialAdController>(() =>
        SplashInterstitialAdController(), fenix: true);
    // Get.lazyPut<SplashInterstitialManager>(() => SplashInterstitialManager(), fenix: true);
    Get.lazyPut<RemoveAds>(() => RemoveAds(), fenix: true);
  }
}