import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateInfo {
  const ForceUpdateInfo({required this.storeUrl});

  final String storeUrl;
}

class ForceUpdateService {
  ForceUpdateService._();

  static const _androidMinimumBuildKey = 'tabibak_android_minimum_build';
  static const _iosMinimumBuildKey = 'tabibak_ios_minimum_build';
  static const _androidStoreUrlKey = 'tabibak_android_store_url';
  static const _iosStoreUrlKey = 'tabibak_ios_store_url';

  static Future<ForceUpdateInfo?> checkForRequiredUpdate() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await remoteConfig.setDefaults(const {
        _androidMinimumBuildKey: 0,
        _iosMinimumBuildKey: 0,
        _androidStoreUrlKey: '',
        _iosStoreUrlKey: '',
      });
      await remoteConfig.fetchAndActivate();

      final isAndroid = Platform.isAndroid;
      if (!isAndroid && !Platform.isIOS) return null;

      final minimumBuild = remoteConfig.getInt(
        isAndroid ? _androidMinimumBuildKey : _iosMinimumBuildKey,
      );
      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      if (currentBuild >= minimumBuild) return null;

      final storeUrl = remoteConfig.getString(
        isAndroid ? _androidStoreUrlKey : _iosStoreUrlKey,
      );
      return ForceUpdateInfo(storeUrl: storeUrl);
    } catch (_) {
      // Do not lock users out if Remote Config is temporarily unavailable.
      return null;
    }
  }
}
