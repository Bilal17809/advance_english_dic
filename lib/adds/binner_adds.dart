import 'package:electricity_app/adds/open_screen.dart';
import 'package:electricity_app/adds/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}
class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdEnabled = true;

  final removeAds = Get.find<RemoveAds>();

  @override
  void initState() {
    super.initState();
    _fetchRemoteConfigAndLoadAd();
    loadBannerAd();
  }

  Future<void> _fetchRemoteConfigAndLoadAd() async {
    try {
      await RemoteConfigService().init();
      final showBanner = RemoteConfigService().getBool('BannerAd');
      if (!mounted) return;
      setState(() => _isAdEnabled = showBanner);
      if (showBanner) {
        loadBannerAd();
      }
    }
    catch (e) {
      print('RemoteConfig error: $e');
    }
  }

  void loadBannerAd() async{
    AdSize? adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );
    _bannerAd = BannerAd(
      adUnitId:'ca-app-pub-5405847310750111/4643895749',
      size:adSize!,
      request: const AdRequest(extras: {'collapsible': 'bottom'}),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad failed: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appOpenAdController = Get.find<AppOpenAdController>();
    return Obx(() {
      if (!_isAdEnabled ||
          removeAds.isSubscribedGet.value ||
          appOpenAdController.isShowingOpenAd.value) {
        return const SizedBox();
      }
      return _isAdLoaded && _bannerAd != null
          ? SafeArea(
        child: Container(
          margin: const EdgeInsets.all(2.0),
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width:1.2),
            borderRadius: BorderRadius.circular(2.0),
          ),
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      )
          :  SafeArea(
        child: Shimmer.fromColors(
          baseColor:  Colors.grey[200]!,
          highlightColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        ),
      );
    });
  }
}

