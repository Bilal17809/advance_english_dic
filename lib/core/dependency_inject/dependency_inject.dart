import 'package:electricity_app/adds/instertial_adds.dart';
import 'package:electricity_app/adds/open_screen.dart';
import 'package:electricity_app/presentations/ai_center/contrl/ai_center_contrl.dart';
import '/presentations/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

import '../../adds/native_adss.dart';
import '../../example/contrl.dart';
import '../../presentations/ai_dictionary/controller/ai_dictionary_controlerl.dart';
import '../../presentations/daily_quiz/controller/quiz_controller.dart';
import '../../presentations/home/contrl/home_contrl.dart';
import '../../presentations/quiz_levels/contrl/quiz_level_contrl.dart';
import '../../presentations/remove_ads_contrl/remove_ads_contrl.dart';
import '../../presentations/them_controller/them_controller.dart';
import '../../presentations/top_word_phrases/contrl/top_word_contrl.dart';
import '../../presentations/word_game/controller/controller.dart';

class DependencyInject{
  static void init() {
    // ads injections
    Get.lazyPut<AppOpenAdController>(() => AppOpenAdController(), fenix: true);
    Get.lazyPut<InterstitialAdController>(() => InterstitialAdController(),
        fenix: true);
    Get.lazyPut<NativeAdController>(() => NativeAdController(), fenix: true);
    Get.lazyPut<SplashInterstitialAdController>(() => SplashInterstitialAdController(), fenix: true);
    Get.lazyPut<RemoveAds>(() => RemoveAds(), fenix: true);

    // controller injection
    Get.lazyPut<RemoveAds>(() => RemoveAds(), fenix: true);

    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<AiCenterController>(() => AiCenterController(), fenix: true);
    Get.lazyPut<DictionaryController>(() => DictionaryController(), fenix: true);
    Get.lazyPut<ConversationController>(() => ConversationController(), fenix: true);
    Get.lazyPut<DailyQuizController>(() => DailyQuizController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<QuizLevelController>(() => QuizLevelController(), fenix: true);
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    Get.lazyPut<TopicController>(() => TopicController(), fenix: true);
    Get.lazyPut<PuzzleController>(() => PuzzleController(), fenix: true);


  }
}