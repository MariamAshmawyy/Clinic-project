import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    final serviceAccountJson = {

      {
        "type": "service_account",
        "project_id": "clinic-project-5e77d",
        "private_key_id": "084a75cff3e8f26fe1aeeee7d710d032ff2b5b7d",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCVtQg7apikc+8P\n0huDjhlfHKWXuumRksuB+oy1lHLLooN+i88og/GbaleYaqEOirnqQ+dVPvlEJqnL\nWhKLIGaoOh1MrEzmVGeUbs+3AcGBt2LPJBLRN20+jLVzmkXi7SwiVWmSdYp6MvJa\nRY1/K1JzHEE0V4C9b289IEx02sKhKcFbImYpoT3sJ/R7JM+JR0N5D/nUQ7Zh1Xn2\nt6dNiL6wiahfHYpXy0kERGaXUXxENU1OawjGT66KGHNbPaMjNsTRN7lOeMHdLNJ3\npxDAmmEPJAT6H16iPLlE81eyuRH+s4L0C9b7jpbdD9OC9l+K92DyZPGX2FA6Bxni\nHm9txVnhAgMBAAECggEAJqIrqC2ni5TxhgsqF4aFrKJXZ3MQUIVp6DaQtlFDWKKt\nPWx1/tYh9QH57fbibj7FoJt6aOjR6dDyc2xgqa+oXlR0+DLku3HfsxHvn6If3kpF\ngQAlrQEZO5GTR+xxiZC8GXYiQu37WPKp0Truu3kiE1ugxhGowvotYkBiCqvjmzQm\nxC6Qx+ModGqIOJlz1if9JGyafETO9JrO3mQIdy9L9P1MOZXdqe8m7Ml4tnbfdPQk\nHN0BYnQG7uLpvDZUEfiRhfPCeUY09t5BoEx16ufe1BPbX/cZvzP+I/hurQdtENHY\nIhIzsr5ctwG7S/C7QGDXOwweOUhxT1+IJwfo2ULkwwKBgQDIjUI+gm7I0F2s0+i+\nVsCj8U3aa8Vpd0fTTPRTYZSqHVuuhdwxOfIxRX7v/CC43OLkCAZJmWSZ9msCryCg\nzGBHZUNYrbszcyQtWxenI7tn8jyvwzt8d8sdURvk7if1GsgF7iqMpB5cvVNl34WU\nCkTN4H53UTny+0vkLfG4N0+dlwKBgQC/GRHjH0zpShf3k/STzZL2cG3KLNe1sapd\npemFHN8TdUILRdZVz+85i+QKHVmWmAurMBSIkgCyhb0oZHw+xKFKvly9IMGzPaB3\na6X4d7x5EnLsrs3CBqJcAgf7ZnAB4+YGVF3S5A7HAtdA6CNj7Y8+Y6A1dUw7HU/Q\ndAglq6MjRwKBgBdqhuWNjSndSlK3m2E999gsgI6ULsSVrMk7HvvtVNJYAzBpaMBG\np8Sg/KVApwFuqP8/AJzvUBO59dymXgToWAV+CVL9VfI3621wSV62iVclrXhIL1Xl\nFs4hfkRImlm/+sLWgBlTwEfLw0UNyCb02/u9zoZX8ZAxTzchNivwKVeZAoGBALAF\nGZLI7AEevIDRicDy5GGXIanOMEsuAS0Ne9GezGOR6GmVxF16kHHDRyOB8VljZ6wh\nN2isg3Ps+FVSaZcvaxn7ylRy7bh6FWqqf1AkijhDJBSa1u/XSInTXSLWMmmrT9+Y\nqmtsoafyF++zY5XR5dWj0pgrGTKCR1hM6Iw6UqRVAoGBAK7azyNDb21IqhqWYVNe\nv5wBUQgxZXdqnwJG8k+nNxpCV4Z8yfSwIXqzDPbt85zmUq2fLe2PdaizxDn+oU9K\nS/dcULlEnHYbDrrSs+tC7rzs3PAGDzjKJHwdLW20Gx/N2MXk5xCv4N1ZonlNB9vb\nQi8vghPesNqmXW+IjvamdGsH\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-fbsvc@clinic-project-5e77d.iam.gserviceaccount.com",
        "client_id": "115877355580431574560",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40clinic-project-5e77d.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }



    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes);

      auth.AccessCredentials credentials =
      await auth.obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client);

      client.close();
      print("Access Token: ${credentials.accessToken.data}"); // Print Access Token
      return credentials.accessToken.data;
    } catch (e) {
      print("Error getting access token: $e");
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
      var serverKeyAuthorization = await getAccessToken();

      // change your project id
      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects/untitled-a464e/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

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