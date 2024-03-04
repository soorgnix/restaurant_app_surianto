import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/common/navigation.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/preferences_provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:restaurant_app/provider/scheduling_provider.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:restaurant_app/ui/home_page.dart';
import 'package:restaurant_app/ui/restaurant_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  
  service.initializeIsolate();
  
  await AndroidAlarmManager.initialize();
  
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
 
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService(), filter: ''),
        ),
        ChangeNotifierProvider(
          create: (_) => SchedulingProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              appBarTheme: AppBarTheme(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
              scaffoldBackgroundColor: Colors.grey.shade100,            
              visualDensity: VisualDensity.adaptivePlatformDensity        
            ),
            navigatorKey: navigatorKey,
            initialRoute: HomePage.routeName,
            routes: {        
              HomePage.routeName: (context) => const HomePage(),
              RestaurantDetailsPage.routeName: (context) => RestaurantDetailsPage(restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant)
            }
          );
        }
      )
    );
  }
}
