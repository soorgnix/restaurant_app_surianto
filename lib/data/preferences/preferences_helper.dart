import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  static const restaurantNotification = 'RESTAURANT_NOTIFICATION';
 
  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isRestaurantNotificationEnabled async {
    final prefs = await sharedPreferences;
    return prefs.getBool(restaurantNotification) ?? false;
  }
  
  void setRestaurantNotificationEnabled(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(restaurantNotification, value);
  }
}