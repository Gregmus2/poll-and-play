import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:poll_and_play/config.dart';
import 'package:poll_and_play/grpc/user.dart';
import 'package:poll_play_proto_gen/public.dart';

// todo add background messages for android
class CloudMessaging {
  final UserClient _client;

  CloudMessaging(this._client);

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: kIsWeb ? GlobalConfig().vapidKey : null);
    _client.registerDevice(fcmToken, kIsWeb ? Platform.PLATFORM_WEB : Platform.PLATFORM_ANDROID);

    _listenForToken();
    _listenForMessage();
  }

  void _listenForToken() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // todo remove old token
      _client.registerDevice(fcmToken, Platform.PLATFORM_ANDROID);
    }).onError((err) {
      // todo handle err
      print(err);
    });
  }

  void _listenForMessage() async {
    // foreground messages handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      // todo handle notifications

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

// todo https://firebase.google.com/docs/cloud-messaging/flutter/receive#handling_interaction open target page
}
