import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateInfo {
  const ForceUpdateInfo({required this.storeUrl});

  final String storeUrl;
}

class ForceUpdateService {
  ForceUpdateService._();

  static const _androidMinimumBuildKey = 'tabibak_clinic_android_minimum_build';
  static const _iosMinimumBuildKey = 'tabibak_clinic_ios_minimum_build';
  static const _androidStoreUrlKey = 'tabibak_clinic_android_store_url';
  static const _iosStoreUrlKey = 'tabibak_clinic_ios_store_url';

  static Future<ForceUpdateInfo?> checkForRequiredUpdate() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      await remoteConfig.setDefaults(const {
        _androidMinimumBuildKey: 0,
        _iosMinimumBuildKey: 0,
        _androidStoreUrlKey: '',
        _iosStoreUrlKey: '',
      });
      final activated = await remoteConfig.fetchAndActivate();

      final isAndroid = Platform.isAndroid;
      if (!isAndroid && !Platform.isIOS) return null;

      final minimumKey =
          isAndroid ? _androidMinimumBuildKey : _iosMinimumBuildKey;
      final minimumBuild = remoteConfig.getInt(minimumKey);
      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      final buildNeedsUpdate = minimumBuild > 0 && currentBuild < minimumBuild;
      debugPrint(
        '[ForceUpdate] fetchActivated=$activated, '
        'fetchStatus=${remoteConfig.lastFetchStatus}, '
        'appVersion=${packageInfo.version}+${packageInfo.buildNumber}, '
        'minimumBuild=$minimumBuild',
      );
      if (!buildNeedsUpdate) return null;

      final storeUrl = remoteConfig.getString(
        isAndroid ? _androidStoreUrlKey : _iosStoreUrlKey,
      );
      return ForceUpdateInfo(storeUrl: storeUrl);
    } catch (error, stackTrace) {
      debugPrint('[ForceUpdate] Check failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

}
