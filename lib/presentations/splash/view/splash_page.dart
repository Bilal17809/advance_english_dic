import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import '../../../adds/instertial_adds.dart';
import '../../home/view/home_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../subscription/subscription_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final SplashInterstitialAdController splashinterstitialAdController=
  Get.put(SplashInterstitialAdController());

  bool isFinished = false;

  @override
  void initState() {
    splashinterstitialAdController.loadInterstitialAd();
    super.initState();
  }
  Future<void> showSubscriptionDialog(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 100));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Subscriptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.blue,
      Colors.orange,
      Colors.red,
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;
          bool isSmallScreen = screenWidth < 600;
          return Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  isSmallScreen
                      ? "assets/adv_splash.jpg"
                      : "assets/splash12.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.68),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.1,
                          left: screenWidth * 0.12,
                          right: screenWidth * 0.12,
                        ),
                        child: SwipeableButtonView(
                          buttonText: 'SLIDE TO CONTINUE',
                          buttonWidget: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          ),
                          activeColor:Colors.red.shade400,
                          isFinished: isFinished,
                          onWaitingProcess: () {
                            Future.delayed(const Duration(seconds:5), () {
                              setState(() {
                                isFinished = true;
                              });
                            });
                          },
                          onFinish: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            bool hasSeenDialog =
                                prefs.getBool('hasSeen') ?? false;
                            if (!hasSeenDialog) {
                              await showSubscriptionDialog(context);
                              await prefs.setBool('hasSeen', true);
                            }
                            if (!removeAds.isSubscribedGet.value) {
                              if (splashinterstitialAdController.isAdReady.value) {
                                await splashinterstitialAdController.showInterstitialAd();
                              }
                            }
                            Get.off(() => HomePage());
                            setState(() {
                              isFinished = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

