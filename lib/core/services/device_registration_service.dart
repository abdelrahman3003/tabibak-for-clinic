import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceRegistrationService {
  DeviceRegistrationService._();

  static const _deviceIdStorageKey = 'notification_device_id';
  static const _storage = FlutterSecureStorage();

  static Future<bool> registerCurrentDevice({String? fcmToken}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    final deviceId = await _getOrCreateDeviceId();
    final platform = Platform.isAndroid
        ? 'android'
        : Platform.isIOS
            ? 'ios'
            : 'other';

    final registered = await Supabase.instance.client.rpc(
      'register_my_device',
      params: {
        'p_device_id': deviceId,
        'p_fcm_token': fcmToken,
        'p_platform': platform,
      },
    );

    return registered == true;
  }

  static Future<void> unregisterCurrentDevice() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final deviceId = await _storage.read(key: _deviceIdStorageKey);
    if (deviceId == null) return;

    await Supabase.instance.client.rpc(
      'unregister_my_device',
      params: {'p_device_id': deviceId},
    );
  }

  static Future<String> _getOrCreateDeviceId() async {
    final storedDeviceId = await _storage.read(key: _deviceIdStorageKey);
    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      return storedDeviceId;
    }

    final random = Random.secure();
    final deviceId = List<int>.generate(32, (_) => random.nextInt(256))
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    await _storage.write(key: _deviceIdStorageKey, value: deviceId);
    return deviceId;
  }
}
