import 'package:electricity_app/adds/open_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../presentations/remove_ads_contrl/remove_ads_contrl.dart';

// class LargeNativeAdController extends GetxController {
//   final String adUnitId = 'ca-app-pub-5405847310750111/2383705045';
//   final RemoveAds removeAds = Get.put(RemoveAds());
//   final Map<String, Rx<Widget>> adWidgets = {};
//   NativeAd? _nativeAd;
//   bool isAdReady = false;
//   bool showAd = false;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeRemoteConfig();
//   }
//
//   Future<void> initializeRemoteConfig() async {
//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 1),
//       ));
//       await remoteConfig.fetchAndActivate();
//
//       showAd = remoteConfig.getBool('NativeAdvAd');
//
//       if (showAd) {
//         loadNativeAd();
//       }
//     } catch (e) {
//       print('Error fetching Remote Config: $e');
//     }
//   }
//
//   void loadNativeAd() {
//     _nativeAd = NativeAd(
//       adUnitId: adUnitId,
//       request: const AdRequest(),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium,
//         mainBackgroundColor: Colors.white,
//       ),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           isAdReady = true;
//           updateAllAdWidgets();
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           isAdReady = false;
//           updateAllAdWidgets();
//         },
//       ),
//     );
//
//     _nativeAd!.load();
//   }
//
//   void updateAllAdWidgets() {
//     final screenHeight = MediaQuery.of(Get.context!).size.height;
//     final adHeight = screenHeight * 0.37;
//     if(removeAds.isSubscribedGet.value){
//       SizedBox();
//     }
//     for (var key in adWidgets.keys) {
//       adWidgets[key]!.value = isAdReady && _nativeAd != null
//           ? Container(
//         height: 300,
//         margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: AdWidget(ad: _nativeAd!),
//       )
//           : shimmerWidget(adHeight);
//     }
//   }
//   Widget nativeAdWidget(String key) {
//     final screenHeight = MediaQuery.of(Get.context!).size.height;
//     final adHeight = screenHeight * 0.37;
//     // Initialize if not already
//     adWidgets.putIfAbsent(key, () => Rx<Widget>(shimmerWidget(adHeight)));
//
//     return Obx(() => adWidgets[key]!.value);
//   }
//
//   Widget shimmerWidget(double width) {
//     return Shimmer.fromColors(
//       baseColor:kWhiteEF,
//       highlightColor: Colors.grey.shade100,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Shimmer Image
//             AspectRatio(
//               aspectRatio: 18 / 8,
//               child: Container(
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             // First Text Line
//             Container(
//               width: double.infinity,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // Second Text Line
//             Container(
//               width: width * 0.7,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }
//
// class NativeAdController extends GetxController {
//   NativeAd? _nativeAd;
//   final RxBool isAdReady = false.obs;
//
//   void loadNativeAd() {
//     isAdReady.value = false;
//     _nativeAd = NativeAd(
//       adUnitId: "ca-app-pub-5405847310750111/2383705045",
//       //"ca-app-pub-3940256099942544/3986624511",
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           _nativeAd = ad as NativeAd;
//           isAdReady.value = true;
//         },
//         onAdFailedToLoad: (ad, error) {
//           isAdReady.value = false;
//           ad.dispose();
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         mainBackgroundColor: Colors.white,
//         templateType: TemplateType.small,
//       ),
//     );
//     _nativeAd!.load();
//   }
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }
// class MyNativeAdWidget extends StatefulWidget {
//   const MyNativeAdWidget({Key? key}) : super(key: key);
//   @override
//   _MyNativeAdWidgetState createState() => _MyNativeAdWidgetState();
// }
// class _MyNativeAdWidgetState extends State<MyNativeAdWidget> {
//   late final NativeAdController _adController;
//   late final String _tag;
//   final RemoveAds removeAds = Get.find<RemoveAds>();
//
//   @override
//   void initState() {
//     super.initState();
//     _tag = UniqueKey().toString();
//     _adController = Get.put(NativeAdController(), tag: _tag);
//     _adController.loadNativeAd();
//   }
//
//   @override
//   void dispose() {
//     Get.delete<NativeAdController>(tag: _tag);
//     super.dispose();
//   }
//   Widget shimmerWidget(double width) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade100,
//       highlightColor: Colors.grey.shade300,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 55 / 15,
//               child: Container(
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               width: double.infinity,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               width: width * 0.7,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // The main build method
//   @override
//   Widget build(BuildContext context) {
//     if (removeAds.isSubscribedGet.value) {
//       return const SizedBox();
//     }
//
//     final screenHeight = MediaQuery.of(context).size.height;
//     final adHeight = screenHeight * 0.14;
//
//     return Obx(() {
//       if (_adController.isAdReady.value && _adController._nativeAd != null) {
//         return Container(
//           height: adHeight,
//           margin: const EdgeInsets.symmetric(vertical: 5),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: AdWidget(ad: _adController._nativeAd!),
//         );
//       } else {
//         return shimmerWidget(adHeight);
//       }
//     });
//   }
// }

// %%%%%%%%%%%%%%%%%%% $$$$$$$$$ %%%%%%%%%%%%%%%%%%%%%
// class NativeAdController extends GetxController {
//   NativeAd? _nativeAd;
//   bool isAdReady = false;
//   bool showAd = false;
//   final Rx<Widget> adWidget = Rx<Widget>(SizedBox.shrink());
//   final RemoveAds removeAds = Get.put(RemoveAds());
//
//   @override
//   void onInit() {
//     super.onInit();
//     initializeRemoteConfig();
//   }
//
//   Future<void> initializeRemoteConfig() async {
//     try {
//       final remoteConfig = FirebaseRemoteConfig.instance;
//       await remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 1),
//       ));
//       await remoteConfig.fetchAndActivate();
//       showAd = remoteConfig.getBool("NativeAdvAd");
//       if (showAd) {
//         loadNativeAd();
//       }
//     } catch (e) {
//       print('Error fetching Remote Config: $e');
//     }
//   }
//
//   void loadNativeAd() {
//     _nativeAd = NativeAd(
//       adUnitId:"ca-app-pub-5405847310750111/2383705045",
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           isAdReady = true;
//           updateAdWidget();
//         },
//         onAdFailedToLoad: (ad, error) {
//           isAdReady = false;
//           ad.dispose();
//           updateAdWidget();
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         mainBackgroundColor: Colors.white,
//         templateType: TemplateType.small,
//       ),
//     );
//
//     _nativeAd!.load();
//   }
//
//   void updateAdWidget() {
//     final screenHeight = MediaQuery.of(Get.context!).size.height;
//     final adHeight = screenHeight * 0.14;
//     if (isAdReady && _nativeAd != null) {
//       adWidget.value = Container(
//         height: adHeight,
//         margin: const EdgeInsets.symmetric(vertical:5,),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: AdWidget(ad: _nativeAd!),
//       );
//     } else {
//       adWidget.value = shimmerWidget(adHeight);
//     }
//   }
//
//   Widget shimmerWidget(double width) {
//     return Shimmer.fromColors(
//       baseColor: Colors.black12,
//       highlightColor: Colors.grey.shade100,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20,),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Shimmer Image
//             AspectRatio(
//               aspectRatio: 55 / 15,
//               child: Container(
//                 width: width,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(height:10),
//             // First Text Line
//             Container(
//               width: double.infinity,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             const SizedBox(height:10),
//             Container(
//               width: width * 0.7,
//               height:12,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget nativeAdWidget() {
//     if (removeAds.isSubscribedGet.value) {
//       return const SizedBox();
//     }
//     else{
//       return Obx(() => adWidget.value);
//     }
//   }
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
// }






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
    Key? key,
    this.templateType = TemplateType.small,
  }) : super(key: key);

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
