import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(minutes: 1),
  }) async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }
}
