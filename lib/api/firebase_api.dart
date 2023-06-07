import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:subscribeme_mobile/service_locator/navigation_service.dart';
import 'package:subscribeme_mobile/service_locator/service_locator.dart';
import 'package:subscribeme_mobile/widgets/subs_flushbar.dart';

// FIREBASE MESSAGING HANDLER
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");
}

class FirebaseMessagingApi {
  final _messagingInstance = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    final fcmToken = await _messagingInstance.getToken();
    log('FCM token: $fcmToken');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      if (message.notification != null) {
        final currentContext =
            locator<NavigationService>().navigatorKey.currentContext;
        log('Message also contained a notification: ${message.notification}');
        SubsFlushbar.showNotification(
          currentContext!,
          message.notification!.title!,
          message.notification!.body!,
        );
      }
    });
  }
}
