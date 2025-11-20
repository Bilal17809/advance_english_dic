import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../adds/splash_app_open.dart';
import '../../home/view/home_page.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../../subscription/subscription_view.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final RemoveAds removeAds = Get.put(RemoveAds());
  final SplashAppOpenAds splashAppOpenAds =
  Get.put(SplashAppOpenAds());

  bool isButtonEnabled = false;
  bool isFinished = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    splashAppOpenAds.loadAppOpenAd();
    startProgress();
  }

  void startProgress() {
    const totalDuration =6;
    const tick = 0.05;
    int ticks = 0;
    int maxTicks = (totalDuration / tick).round();

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      ticks++;
      setState(() {
        progress = ticks / maxTicks;
      });

      if (ticks >= maxTicks) {
        timer.cancel();
        setState(() {
          isButtonEnabled = true;
        });
      }
    });
  }

  Future<void> showSubscriptionDialog(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 100));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Subscriptions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Stack(
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

          // Center content
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.68),
              child: Column(
                children: [
                  if (!isButtonEnabled)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // rounded edges
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 16,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.red.shade400),
                        ),
                      ),
                    ),

                  if (isButtonEnabled)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: screenHeight * 0.1,
                        left: screenWidth * 0.12,
                        right: screenWidth * 0.12,
                      ),
                      child: SwipeableButtonView(
                        buttonText: 'SLIDE TO CONTINUE',
                        buttonWidget: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                        ),
                        activeColor: Colors.red.shade400,
                        isFinished: isFinished,
                        onWaitingProcess: () async {
                          // Wait 3 seconds
                          await Future.delayed(const Duration(seconds:4));
                          setState(() => isFinished = true);
                        },
                        onFinish: () async {
                          setState(() {
                            isFinished = true;
                          });
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          bool hasSeenDialog = prefs.getBool('hasSeen') ?? false;
                          if (!hasSeenDialog) {
                            await showSubscriptionDialog(context);
                            await prefs.setBool('hasSeen', true);
                          }
                          if (splashAppOpenAds.isAdReady.value) {
                            await splashAppOpenAds.showAppOpenAd();
                          }
                          Get.off(() => HomePage());
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





