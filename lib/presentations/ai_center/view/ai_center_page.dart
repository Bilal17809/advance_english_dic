import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:electricity_app/presentations/subscription/subscription_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../ai_translator/controller/speak_dialog_contrl.dart';
import '/adds/instertial_adds.dart';
import '/core/common_widgets/bg_circular.dart';
import '/core/common_widgets/icon_buttons.dart';
import '/core/common_widgets/round_image.dart';
import '/core/common_widgets/textform_field.dart';
import '/core/constant/constant.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_styles.dart';
import '../../remove_ads_contrl/remove_ads_contrl.dart';
import '../contrl/ai_center_contrl.dart';

class OpenRouterPage extends StatefulWidget {
  @override
  State<OpenRouterPage> createState() => _OpenRouterPageState();
}
class _OpenRouterPageState extends State<OpenRouterPage> with SingleTickerProviderStateMixin{
  final controller = Get.put(AiCenterController());
  final TextEditingController textController = TextEditingController();
  final SpeakDialog speakDialog = Get.put(SpeakDialog());

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final RemoveAds removeAds = Get.put(RemoveAds());
  final InterstitialAdController interstitialAdController=Get.put(InterstitialAdController());

  Timer? _hintTimer;
  int _hintIndex = 0;
  @override
  @override
  void initState() {
    super.initState();
    controller.responseText.value = '';
    if (!removeAds.isSubscribedGet.value) {
      interstitialAdController.checkAndShowAd();
    }

    // 🎯 Faster, dancing animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // much faster
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    controller.hintText.value = controller.hintMessages[0];
    controller.hintTextColor.value = controller.hintColors[0];
    _hintTimer = Timer.periodic(Duration(seconds:3), (timer) {
      _hintIndex = (_hintIndex + 1) % controller.hintMessages.length;
      controller.hintText.value = controller.hintMessages[_hintIndex];
      controller.hintTextColor.value = controller.hintColors[_hintIndex % controller.hintColors.length];
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel();
    _animationController.dispose();
    textController.dispose();
    super.dispose();
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
                      "AI Checker",
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
          Padding(
            padding:  EdgeInsets.only(top:90, left: kBodyHp, right: kBodyHp),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Container(
                decoration: roundedDecoration,
                padding: const EdgeInsets.all(10),
                child: Obx(() => SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(() => Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Row(
                              key: ValueKey(controller.hintText.value),
                              children: [
                                RotationTransition(
                                  turns: Tween(begin: -0.05, end: 0.05).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Curves.linear,
                                    ),
                                  ),
                                  child: ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Icon(
                                      Icons.smart_toy_rounded,
                                      color: Colors.blue,
                                      size: 25,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    controller.hintText.value,
                                    style: TextStyle(
                                      color: controller.hintTextColor.value,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                      SizedBox(height:16,),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.23,
                        padding: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: CustomTextFormField(
                                  textAlign: TextAlign.start,
                                  hintText: 'Ask Anything...',
                                  controller: textController,
                                  onChanged: (val) => controller.inputText.value = val,
                                ),
                              ),
                            ),

                            SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.keyboard_voice, color: kBlue),
                                    onPressed: () async {
                                      final connectivityResult = await Connectivity().checkConnectivity();
                                      if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                                          !connectivityResult.contains(ConnectivityResult.wifi)) {
                                        if (!context.mounted) return;
                                        await showNoInternetDialog(context);
                                      }else{
                                        await showSpeakDialog(context, controller, textController);
                                        if (controller.inputText.value.isNotEmpty) {
                                          controller.generateResponse(context);
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel, color: kBlue),
                                    onPressed: () {
                                      textController.clear();
                                      controller.inputText.value = '';
                                    },
                                    tooltip: 'Clear text',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy, color: kBlue),
                                    onPressed: () {
                                      if (controller.inputText.value.isNotEmpty) {
                                        Clipboard.setData(ClipboardData(text: controller.inputText.value));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      Obx(() {
                        final AiCenterController controller = Get.find<AiCenterController>();
                        final int remaining = controller.maxFreeInteractions - controller.interactionCount.value;

                        return RichText(
                          text: TextSpan(
                            text: 'Daily Limit Remaining=$remaining ', // Dynamically update the number
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'GO Premium',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => Subscriptions());
                                  },
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () async {
                          final connectivityResult = await Connectivity().checkConnectivity();

                          // If no internet
                          if (!connectivityResult.contains(ConnectivityResult.mobile) &&
                              !connectivityResult.contains(ConnectivityResult.wifi)) {
                            if (!context.mounted) return;
                            await showNoInternetDialog(context);
                            return;
                          }

                          // If connected, proceed
                          await controller.generateResponse(Get.context!);
                          // controller.generateResponse(context);
                        },
                        child: controller.isLoading.value
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text("Generate"),
                      ),
                      controller.responseText.value.isEmpty?
                      SizedBox(height: MediaQuery.of(context).size.height * 0.08)
                      :SizedBox(height: 22,),
                      controller.responseText.value.isEmpty
                          ? Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        alignment: Alignment.center,
                        child: RotationTransition(
                          turns: Tween(begin: -0.05, end: 0.05).animate(_animationController),
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Image.asset(
                              'assets/deepseek.png',
                              fit: BoxFit.contain,
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),

                      )
                          :
                      Container(
                        height: MediaQuery.of(context).size.height * 0.34,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: SingleChildScrollView(
                                  child: Text(
                                    controller.responseText.value,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.copy, color: kBlue),
                                    tooltip: 'Copy',
                                    onPressed: () {
                                      if (controller.responseText.value.isNotEmpty) {
                                        Clipboard.setData(ClipboardData(text: controller.responseText.value));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Text copied to clipboard'),
                                            duration: Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.share, color: kBlue),
                                    tooltip: 'Share',
                                    onPressed: () {
                                      if (controller.responseText.value.isNotEmpty) {
                                        Share.share(controller.responseText.value);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showSpeakDialog(
    BuildContext context,
    AiCenterController controller,
    TextEditingController textController,
    ) async {
  controller.recognizedText.value = '';
  final RxBool timedOut = false.obs;
  controller.startSpeechToText(context);
  Future.delayed(const Duration(milliseconds: 5600), () {
    if (controller.recognizedText.value.isEmpty) {
      controller.stopListening();
      timedOut.value = true;
    }
  });

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Voice Icon
                Obx(() {
                  return AnimatedRoundedButton(
                    backgroundColor: skyBorderColor.withOpacity(0.4),
                    child: Icon(
                      Icons.keyboard_voice,
                      color: timedOut.value ? Colors.red : kBlue,
                      size: 55,
                    ),
                    onTap: () {},
                  );
                }),

                const SizedBox(height: 20),

                /// Recognized Text or Status
                Obx(() {
                  return Center(
                    child: Text(
                      controller.recognizedText.value.isEmpty
                          ? (timedOut.value ? "No speech detected" : "Listening...")
                          : controller.recognizedText.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
                const SizedBox(height:26),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.stopListening();
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: timedOut.value ? Colors.orange : Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            controller.stopListening();
                            if (timedOut.value) {
                              controller.recognizedText.value = '';
                              timedOut.value = false;
                              controller.startSpeechToText(context);
                            } else {
                              textController.text = controller.recognizedText.value;
                              Navigator.pop(dialogContext);
                            }
                          },
                          child: Text(timedOut.value ? "Try Again" : "OK"),
                        ),
                      ),
                    ],
                  );
                }),

              ],
            ),
          ),
        ),
      );
    },
  );
}




