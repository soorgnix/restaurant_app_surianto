import 'dart:convert';

class Restaurants{
  List<Restaurant> restaurants;

  Restaurants({
    required this.restaurants
  });

  factory Restaurants.fromJson(Map<String, dynamic> restaurants) {
    var list = restaurants['restaurants'] as List;
    List<Restaurant> restaurantList =
        list.map((restaurant) => Restaurant.fromJson(restaurant)).toList();

    return Restaurants(restaurants: restaurantList);
  }
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final num rating;
  final RestaurantMenu menus;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus
  });

  factory Restaurant.fromJson(Map<String, dynamic> restaurant) => Restaurant(
    id: restaurant['id'],
    name: restaurant['name'],
    description: restaurant['description'],
    pictureId: restaurant['pictureId'],
    city: restaurant['city'],
    rating: restaurant['rating'],
    menus: RestaurantMenu.fromJson(restaurant['menus']),
  );
}

class RestaurantMenu {
  final List<RestaurantMenuItem> foods;
  final List<RestaurantMenuItem> drinks;

  RestaurantMenu({
    required this.foods,
    required this.drinks
  });

  factory RestaurantMenu.fromJson(Map<String, dynamic> restaurantMenu) {
    var foodsList = restaurantMenu['foods'] as List;
    List<RestaurantMenuItem> foods =
        foodsList.map((foods) => RestaurantMenuItem.fromJson(foods)).toList();

    var drinksList = restaurantMenu['drinks'] as List;
    List<RestaurantMenuItem> drinks =
        drinksList.map((drinks) => RestaurantMenuItem.fromJson(drinks)).toList();

    return RestaurantMenu(foods: foods, drinks: drinks);
  }
}

class RestaurantMenuItem {
  final String name;

  RestaurantMenuItem({
    required this.name
  });

  factory RestaurantMenuItem.fromJson(Map<String, dynamic> restaurantMenuItem) => RestaurantMenuItem(
    name: restaurantMenuItem['name']
  );
}

List<Restaurant> parseRestaurant(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);
  return Restaurants.fromJson(parsed).restaurants;
}