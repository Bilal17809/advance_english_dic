import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../presentations/ai_dictionary/view/ai_dictionary_page.dart';
import '../../presentations/ai_translator/view/ai_translator_page.dart';
import '../../presentations/part_of_spech/view/part_of_spech_page.dart';
import '../../presentations/speech_example/view/speech_example.dart';
import '../../presentations/splash/view/splash_page.dart';
import 'routes_name.dart';
import '../../presentations/home/view/home_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (_) =>  SplashPage());

      case RoutesName.homePage:
        return MaterialPageRoute(builder: (_) =>  HomePage());

      case RoutesName.aiDictionaryPage:
        return MaterialPageRoute(builder: (_) => const AiDictionaryPage());

      case RoutesName.aiTranslatorPage:
        return MaterialPageRoute(builder: (_) =>  AiTranslatorPage());

      case RoutesName.partOfSpeechPage:
        return MaterialPageRoute(builder: (_) => const PartOfSpechPage());

      case RoutesName.partOfSpeechExamplePage:
        if (arguments is PartOfSpeech) {
          return MaterialPageRoute(
            builder: (_) => PartOfSpeechExamplePage(part: arguments),
          );
        }
        return _errorRoute('Invalid argument for PartOfSpeechExamplePage');

      default:
        return _errorRoute('No route defined for "${settings.name}"');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}
