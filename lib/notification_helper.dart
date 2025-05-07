import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
class NotificationsHelper {
  // creat instance of fbm
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // initialize notifications for this app or device
  Future<void> initNotifications() async {
    // Request permission to receive notifications
    await _firebaseMessaging.requestPermission();

    // Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotificationsPlugin.initialize(initSettings);

    // Get the device token
    String? deviceToken = await _firebaseMessaging.getToken();
    print("===================Device FirebaseMessaging Token====================");
    // print(deviceToken);
    print("===================Device FirebaseMessaging Token====================");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("====Foreground Notification Received====");
      print("Message Title: ${message.notification?.title}");
      print("Message Body: ${message.notification?.body}");

      // Optionally show a local notification here
      _showLocalNotification(message);
    });
  }

// Show a local notification using flutter_local_notifications
  void _showLocalNotification(RemoteMessage message) {
    // You can integrate flutter_local_notifications here for better UI
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      _localNotificationsPlugin.show(
        notification.hashCode, // Notification ID
        notification.title,    // Notification Title
        notification.body,     // Notification Body
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Channel ID
            'High Importance Notifications', // Channel Name
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }


  }


  // handle notifications when received
  void handleMessages(RemoteMessage? message) {
    if (message != null) {
      // navigatorKey.currentState?.pushNamed(NotificationsScreen.routeName, arguments: message);
      print("hello");
    }
  }
  // handel notifications in case app is terminated
  void handleBackgroundNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((handleMessages));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessages);
  }

  Future<String?> getAccessToken() async {
    try {
      // 1. Load the JSON text from assets
      final saString = await rootBundle.loadString('assets/Clinic-project-5e77d.json');
      final Map<String, dynamic> saMap = jsonDecode(saString);

      // 2. Create credentials & client
      final creds  = auth.ServiceAccountCredentials.fromJson(saMap);
      const scopes = [
        'https://www.googleapis.com/auth/firebase.messaging',
      ];

      final client = await auth.clientViaServiceAccount(creds, scopes);

      // 3. Read the short‑lived OAuth2 token
      final token  = client.credentials.accessToken.data;
      client.close();
      return token;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Map<String, dynamic> getBody({
    required String topic,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) {
    return {
      "message": {
        "topic": topic,
        "notification": {"title": title, "body": body},
        "android": {
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default"
          }
        },
        "apns": {
          "payload": {
            "aps": {"content_available": true}
          }
        },
        "data": {
          "type": type,
          "id": userId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      }
    };
  }

  Future<void> sendNotifications({
    required String topic,
    required String title,
    required String body,
    required String userId,
    String? type,
  }) async {
    try {
      final accessToken = await getAccessToken();    // NEW line‑1
      if (accessToken == null) {                    // NEW line‑2
        print('Cannot send: access token is null'); // NEW line‑3
        return;                                     // NEW line‑4
      }                                             // NEW line‑5

      // change your project id
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/clinic-project-5e77d/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      var response = await dio.post(
        urlEndPoint,
        data: getBody(
          userId: userId,
          topic: topic,
          title: title,
          body: body,
          type: type ?? "message",
        ),
      );

      // Print response status code and body for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}