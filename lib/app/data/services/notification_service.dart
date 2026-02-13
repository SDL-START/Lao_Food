import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../core/utils/logger_utils.dart';
import 'auth_service.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Request permissions
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notification setup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android notification channel
    const channel = AndroidNotificationChannel(
      'lao_food_channel',
      'Lao Food Notifications',
      description: 'ແຈ້ງເຕືອນຈາກ Lao Food',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // FCM Token
    final token = await _messaging.getToken();
    if (token != null) {
      Log.i('FCM Token: $token');
      final authService = Get.find<AuthService>();
      await authService.updateFcmToken(token);
    }

    // Token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      final authService = Get.find<AuthService>();
      authService.updateFcmToken(newToken);
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background/Terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    Log.i('Foreground message: ${message.notification?.title}');
    _showLocalNotification(
      title: message.notification?.title ?? 'Lao Food',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    Log.i('Message opened app: ${message.data}');
    // Navigate based on data
    _navigateFromNotification(message.data);
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'lao_food_channel',
        'Lao Food Notifications',
        channelDescription: 'ແຈ້ງເຕືອນຈາກ Lao Food',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    Log.i('Notification tapped: ${response.payload}');
  }

  void _navigateFromNotification(Map<String, dynamic> data) {
    // Navigate based on notification data
    final type = data['type'];
    final orderId = data['orderId'];

    if (type == 'order_update' && orderId != null) {
      // Navigate to order detail
      Log.i('Navigate to order: $orderId');
    } else if (type == 'chat') {
      final chatId = data['chatId'];
      Log.i('Navigate to chat: $chatId');
    }
  }

  /// ── Send local notification (for triggers) ──
  Future<void> showOrderNotification(String title, String body) async {
    await _showLocalNotification(title: title, body: body);
  }
}
