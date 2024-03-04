// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();
 
class NotificationHelper {
  static NotificationHelper? _instance;
 
  NotificationHelper._internal() {
    _instance = this;
  }
 
  factory NotificationHelper() => _instance ?? NotificationHelper._internal();
 
  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('restaurant_icon');
 
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
 
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        print('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }
 
  Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, Restaurant restaurant) async {
    print('show notification');
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "restaurant app channel"; 
 
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName, 
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));
 
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    
    var titleRestaurant = restaurant.name;
    var descRestaurant = "${restaurant.description.substring(0,27)}...";
 
    await flutterLocalNotificationsPlugin.show(
      0, 
      titleRestaurant, 
      descRestaurant, 
      platformChannelSpecifics,
      payload: json.encode(restaurant.toJson())
    );
  }
 
  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));                
        Navigation.intentWithData(route, data);
      },
    );
  }
}