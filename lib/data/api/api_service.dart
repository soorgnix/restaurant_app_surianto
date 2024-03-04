import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_details.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  
  Future<RestaurantFilter> getRestaurantsWithFilter(http.Client client, String filter) async {
    final response = await client.get(Uri.parse("$_baseUrl/search?q=$filter"));
    if (response.statusCode == 200) {
      return RestaurantFilter.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to filter restaurants');
    }
  }


  Future<RestaurantDetails> getRestaurantDetails(http.Client client, String id) async {
    final response = await client.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return RestaurantDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }
}