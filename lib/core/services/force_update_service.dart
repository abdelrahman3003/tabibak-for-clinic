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

  static const _minimumVersionKey = 'minimum_version';
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
        _minimumVersionKey: '',
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
      final minimumValue = remoteConfig.getString(minimumKey).trim();
      final packageInfo = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      final minimumVersion =
          remoteConfig.getString(_minimumVersionKey).trim().isNotEmpty
              ? remoteConfig.getString(_minimumVersionKey).trim()
              : minimumValue;
      final minimumBuild = int.tryParse(minimumValue) ?? 0;
      final versionNeedsUpdate = minimumVersion.isNotEmpty &&
          _compareVersions(packageInfo.version, minimumVersion) < 0;
      final buildNeedsUpdate = minimumBuild > 0 && currentBuild < minimumBuild;
      debugPrint(
        '[ForceUpdate] fetchActivated=$activated, '
        'fetchStatus=${remoteConfig.lastFetchStatus}, '
        'appVersion=${packageInfo.version}+${packageInfo.buildNumber}, '
        'minimumVersion=$minimumVersion, minimumBuild=$minimumBuild',
      );
      if (!versionNeedsUpdate && !buildNeedsUpdate) return null;

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

  static int _compareVersions(String current, String minimum) {
    final currentParts = _versionParts(current);
    final minimumParts = _versionParts(minimum);
    final length = currentParts.length > minimumParts.length
        ? currentParts.length
        : minimumParts.length;

    for (var index = 0; index < length; index++) {
      final currentPart = index < currentParts.length ? currentParts[index] : 0;
      final minimumPart = index < minimumParts.length ? minimumParts[index] : 0;
      if (currentPart != minimumPart) {
        return currentPart.compareTo(minimumPart);
      }
    }
    return 0;
  }

  static List<int> _versionParts(String version) {
    final normalized = version.split('+').first.trim();
    final parts = normalized.split('.');
    if (parts.isEmpty || parts.any((part) => int.tryParse(part) == null)) {
      throw FormatException('Invalid app version: $version');
    }
    return parts.map(int.parse).toList();
  }
}
