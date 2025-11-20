import 'package:electricity_app/adds/open_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

class NativeAdController extends GetxController {
  NativeAd? _nativeAd;
  final RxBool isAdReady = false.obs;
  bool showAd = false;

  final TemplateType templateType;

  NativeAdController({this.templateType = TemplateType.small});

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 3),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      final key = 'NativeAdvAd';
      showAd = remoteConfig.getBool(key);

      if (showAd) {
        loadNativeAd();
      } else {
        print('Native ad disabled via Remote Config.');
      }
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  void loadNativeAd() {
    isAdReady.value = false;

    final adUnitId = 'ca-app-pub-5405847310750111/2383705045';

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _nativeAd = ad as NativeAd;
          isAdReady.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isAdReady.value = false;
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: templateType,
      ),
    );

    _nativeAd!.load();
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}

class NativeAdWidget extends StatefulWidget {
  final TemplateType templateType;

  const NativeAdWidget({
    super.key,
    this.templateType = TemplateType.small,
  });

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  late final NativeAdController _adController;
  late final String _tag;
  final removeAds = Get.find<RemoveAds>();

  @override
  void initState() {
    super.initState();
    _tag = UniqueKey().toString();
    _adController = Get.put(
      NativeAdController(templateType: widget.templateType),
      tag: _tag,
    );
    _adController.loadNativeAd();
  }

  @override
  void dispose() {
    Get.delete<NativeAdController>(tag: _tag);
    super.dispose();
  }

  Widget shimmerWidget(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            AspectRatio(
              aspectRatio: 55 / 15,
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // First Text Line
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.7,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appOpenAdController = Get.find<AppOpenAdController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final adHeight = widget.templateType == TemplateType.medium
        ? screenHeight * 0.48
        : screenHeight * 0.14;
    return Obx((){
      if (removeAds.isSubscribedGet.value
          || appOpenAdController.isShowingOpenAd.value) {
        return const SizedBox();
      }
      return _adController.isAdReady.value && _adController._nativeAd != null
          ? Container(
        height: adHeight,
        margin: const EdgeInsets.symmetric(vertical:5,horizontal:5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius:3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AdWidget(ad: _adController._nativeAd!),
      )
          :shimmerWidget(adHeight);
    });
  }
}
