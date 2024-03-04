import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;  
  bool _isRestaurantNotificationEnabled = false;
  bool get isRestaurantNotificationEnabled => _isRestaurantNotificationEnabled;

  PreferencesProvider({required this.preferencesHelper}) {
    _getRestaurantNotificationPreferences();
  }

  void _getRestaurantNotificationPreferences() async {
    _isRestaurantNotificationEnabled = await preferencesHelper.isRestaurantNotificationEnabled;
    notifyListeners();
  }
 
  void enableRestaurantNotification(bool value) {
    preferencesHelper.setRestaurantNotificationEnabled(value);
    _getRestaurantNotificationPreferences();
  }
}