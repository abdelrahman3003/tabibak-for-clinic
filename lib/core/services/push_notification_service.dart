import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tabibak_for_clinic/core/services/device_registration_service.dart';
import 'package:tabibak_for_clinic/core/services/local_notification_services.dart';

class PushNotificationService {
  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    try {
      await firebaseMessaging.requestPermission();

      final token = await getToken();
      log('------- FCM token: $token');

      firebaseMessaging.onTokenRefresh.listen((token) async {
        if (Supabase.instance.client.auth.currentUser == null) return;
        try {
          await DeviceRegistrationService.registerCurrentDevice(
            fcmToken: token,
          );
        } catch (e, stackTrace) {
          log('------- FCM device registration Error: $e',
              stackTrace: stackTrace);
        }
      });

      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    } catch (e, stackTrace) {
      log(
        '------- Firebase Messaging Error: $e',
        stackTrace: stackTrace,
      );
    }
  }

  static Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await firebaseMessaging.getAPNSToken();

        if (apnsToken == null) {
          log('------- APNs token not available');
          return null;
        }
      }

      return await firebaseMessaging.getToken();
    } catch (e, stackTrace) {
      log(
        '------- FCM getToken Error: $e',
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    LocalNotificationServices.showBasicNotification(message);
  }

  static Future<void> _handleBackgroundMessage(
    RemoteMessage message,
  ) async {
    log('---- message ${message.notification?.title}');
  }
}
