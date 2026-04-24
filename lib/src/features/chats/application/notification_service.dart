import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
      await _setupForegroundNotifications();
      final token = await getToken();
      debugPrint('FCM Token: $token');
    } else {
      debugPrint('User declined notification permission');
    }
  }

  Future<void> _setupForegroundNotifications() async {
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened app: ${message.data}');
    });
  }

  Future<String?> getToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        String? apnsToken;
        int retries = 0;
        while (apnsToken == null && retries < 3) {
          try {
            apnsToken = await _fcm.getAPNSToken();
          } catch (e) {
            debugPrint('Failed to get APNS token: $e');
          }
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 1));
            retries++;
          }
        }
        if (apnsToken == null) {
          debugPrint('APNS token is null after retries');
          return null;
        }
      }
      return await _fcm.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }
}
