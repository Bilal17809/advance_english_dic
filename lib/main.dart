import '/presentations/word_game/controller/controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'adds/instertial_adds.dart';
import 'adds/native_adss.dart';
import 'adds/open_screen.dart';
import 'adds/rewarded_intertitial.dart';
import 'core/dependency_inject/dependency_inject.dart';
import 'core/routes/routes.dart';
import 'core/routes/routes_name.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  DependencyInject.init();
  Get.put(PuzzleController());
  Get.put(AppOpenAdController());
  Get.put(SplashInterstitialAdController());
  Get.put(RewardAdController());
  Get.put(NativeAdController());
  Get.put(InterstitialAdController());
  runApp(const MyApp());
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('6ed1049d-2e30-44e9-b27d-9fd953cf0eb9');
  OneSignal.Notifications.requestPermission(true);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return   ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.themeData,
        initialRoute: RoutesName.splashPage,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
