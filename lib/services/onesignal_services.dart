import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../core/constant/constant.dart';

class OnesignalService {
  static Future<void> init() async {
    if (Platform.isAndroid) {
      OneSignal.initialize('');
      await OneSignal.Notifications.requestPermission(true);
    } else if (Platform.isIOS) {
      OneSignal.initialize('');
      await OneSignal.Notifications.requestPermission(true);
    } else {
      debugPrint("Platform not supported");
    }
  }
}
