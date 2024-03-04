// ignore_for_file: avoid_print

import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/main.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();
 
class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;
 
  BackgroundService._internal() {
    _instance = this;
  }
 
  factory BackgroundService() => _instance ?? BackgroundService._internal();
 
  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }
 
  static Future<void> callback() async {
    print('Alarm fired!');
    http.Client httpClient = http.Client();
    final NotificationHelper notificationHelper = NotificationHelper();
    RestaurantFilter result = await ApiService().getRestaurantsWithFilter(httpClient, '');
    if (result.restaurants.isNotEmpty ) {
      int maxNumber = result.restaurants.length - 1;
      var random = Random();
      int randomNumber = random.nextInt(maxNumber);
      Restaurant restaurant = result.restaurants[randomNumber];
      await notificationHelper.showNotification(flutterLocalNotificationsPlugin, restaurant);
  
      _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
      _uiSendPort?.send(null);
    } else {
      print('No Data to put notification');
    }
  }
}
