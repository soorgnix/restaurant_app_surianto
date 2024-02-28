import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_arguments.dart';
import 'package:restaurant_app/restaurant_details_page.dart';
import 'package:restaurant_app/restaurant_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.grey.shade100,            
        visualDensity: VisualDensity.adaptivePlatformDensity        
      ),
      home: const RestaurantListPage(),
      routes: {
        RestaurantListPage.routeName: (context) => const RestaurantListPage(),
        RestaurantDetailsPage.routeName: (context) => RestaurantDetailsPage(restaurantArguments: ModalRoute.of(context)?.settings.arguments as RestaurantArguments)
      }
    );
  }
}
