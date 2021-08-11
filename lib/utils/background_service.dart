import 'dart:ui';
import 'dart:isolate';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';
import 'package:submission_restaurant_app/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class BackgroundService {
  static BackgroundService _service;
  static String _isolateName = 'isolate';
  static SendPort _uiSendPort;

  BackgroundService._createObject();

  factory BackgroundService() {
    if (_service == null) {
      _service = BackgroundService._createObject();
    }
    return _service;
  }

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper _notificationHelper = NotificationHelper();
    Restaurant result = await ApiService().getRandomRestaurant();
    await _notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  Future<void> someTask() async {
    print('Jalankan beberapa proses');
  }
}
