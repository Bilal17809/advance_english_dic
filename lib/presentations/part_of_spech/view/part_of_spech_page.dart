import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../adds/binner_adds.dart';
import '../../../adds/instertial_adds.dart';
import '../../../adds/native_adss.dart';
import '../../../adds/open_screen.dart';
import '../../../core/common_widgets/bg_circular.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constant/constant.dart';
import '../../../core/theme/app_styles.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../speech_example/view/speech_example.dart';
import '../contrl/contrl.dart';


class PartOfSpechPage extends StatefulWidget {
  const PartOfSpechPage({super.key});

  @override
  State<PartOfSpechPage> createState() => _PartOfSpechPageState();
}
class _PartOfSpechPageState extends State<PartOfSpechPage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final AppOpenAdController appOpenAdController=Get.put(AppOpenAdController());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());
  final controller = Get.put(PartOfSpeechController());
  final nativeAdController = Get.put(NativeAdController());


  @override
  void initState() {
    super.initState();
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundCircles(),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: BackIconButton(),
                  ),
                  Center(
                    child: Text(
                      "Part of speech",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.only(top:80, left: kBodyHp, right: kBodyHp),
              child: Container(
                decoration: roundedDecoration,
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    itemCount: controller.partOfSpeechList.length,
                    itemBuilder: (context, index) {
                      final item = controller.partOfSpeechList[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                        child: Container(
                          decoration: roundedDecoration,
                          padding: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () {
                                Get.to(PartOfSpeechExamplePage(part: item));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(item.word, style: context.textTheme.titleLarge),
                                      const SizedBox(width: 5),
                                      Text(
                                        "(${item.partOfSpeech})",
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  Text(item.meaning),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },

                    /// This is where the ad goes
                    separatorBuilder: (context, index) {
                      final middleIndex = (controller.partOfSpeechList.length / 2).floor();

                      if (index == 2 && !(interstitialAdController.isAdReady.value)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical:8),
                          child:const NativeAdWidget(),
                          //nativeAdController.nativeAdWidget(),
                        );
                      }

                      return const SizedBox(height: 8);
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
