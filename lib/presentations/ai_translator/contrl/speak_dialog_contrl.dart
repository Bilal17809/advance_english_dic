import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../core/common_widgets/country_flag.dart';
import '../../../core/common_widgets/round_image.dart';
import '../../../core/common_widgets/speak_dialog_box.dart';
import '../../../core/theme/app_colors.dart';
import '../../../example/contrl.dart';

class SpeakDialog extends GetxController {
  final ConversationController controller=Get.put(ConversationController());
  void openMicDialog(BuildContext context, bool isRightMic) async {
    final selectedLanguage = isRightMic
        ? controller.selectedLanguageC2.value
        : controller.selectedLanguageC1.value;

    final List<String> supportedLanguages = [
      'English', 'French', 'Spanish', 'German', 'Italian', 'Portuguese', 'Dutch',
      'Russian', 'Chinese (Simplified)', 'Japanese', 'Korean', 'Arabic', 'Hindi',
      'Bengali', 'Turkish', 'Vietnamese', 'Thai', 'Indonesian', 'Tagalog', 'Hebrew',
      'Swedish', 'Norwegian', 'Danish', 'Finnish', 'Polish', 'Greek', 'Czech',
      'Hungarian', 'Romanian', 'Ukrainian',
    ];

    if (!supportedLanguages.contains(selectedLanguage)) {
      showCustomToast(context, 'This language is not supported for speech-to-text!');
      return;
    }
    // ✅ iOS — continue with custom dialog logic
    final RxBool timedOut = false.obs;
    final RxInt micSessionId = DateTime.now().millisecondsSinceEpoch.obs;

    void startListeningSession() {
      controller.recognizedText.value = '';
      timedOut.value = false;

      final currentSessionId = DateTime.now().millisecondsSinceEpoch;
      micSessionId.value = currentSessionId;

      controller.startSpeechToText(context, selectedLanguage, isRightMic);

      /// ⏳ Timeout after 4 seconds if no speech
      Future.delayed(const Duration(seconds: 4), () {
        if (controller.recognizedText.value.isEmpty &&
            micSessionId.value == currentSessionId) {
          controller.stopListening();
          timedOut.value = true;
        }
      });
    }

    startListeningSession();

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
                  Row(
                    children: [
                      CountryFlag.fromCountryCode(
                        languageFlags[selectedLanguage] ?? 'US',
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        selectedLanguage,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  Obx(() {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        controller.recognizedText.value.isEmpty
                            ? (timedOut.value ? "Please try again" : "Listening...")
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
                  const SizedBox(height: 20),
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
                        if (timedOut.value)
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                startListeningSession();
                              },
                              child: const Text("Try Again"),
                            ),
                          )
                        else
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                controller.stopListening();
                                controller.processRecognizedText(isRightMic, context);
                                Navigator.pop(dialogContext);
                              },
                              child: const Text("OK"),
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

}
/// Call this function anywhere to show the beautiful "No Internet" dialog.
Future<void> showNoInternetDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Lottie animation (optional but beautiful!)
              Image.asset(
                'assets/connection.png',
                height: 140,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              /// Title
              const Text(
                "No Internet Connection",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              /// Description
              const Text(
                "An internet connection is required to continue. Please check your connection and try again.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              /// OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.wifi_off),
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    foregroundColor: Colors.white,
                  ),
                  label: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

