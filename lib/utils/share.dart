import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  final SharePlus _sharePlus;

  ShareUtils({required SharePlus sharePlus}) : _sharePlus = sharePlus;

  Future<void> shareText(String text) async {
    try {
      if (text.isEmpty) return;
      final params = ShareParams(text: text);
      await _sharePlus.share(params);
    } catch (e) {
      debugPrint('**** ERROR: $e********');
    }
  }
}
