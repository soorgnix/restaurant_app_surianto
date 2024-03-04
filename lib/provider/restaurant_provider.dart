import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:http/http.dart' as http;

enum ResultState { loading, noData, hasData, error }
 
class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String filter;

  RestaurantProvider({required this.apiService, required this.filter}) {
    _fetchAllRestaurant();
  }
 
  late RestaurantFilter _restaurantFilter;
  late ResultState _state;
  String _message = '';
 
  String get message => _message;
 
  RestaurantFilter get result => _restaurantFilter;
 
  ResultState get state => _state;
 
  Future<dynamic> _fetchAllRestaurant() async {
    try {
      http.Client httpClient = http.Client(); 
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.getRestaurantsWithFilter(httpClient, filter);
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantFilter = restaurants;
      } 
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        return _message = 'Error tidak ada koneksi internet';
      } else {
        return _message = 'Gagal memuat data';
      }
      
    }
  }

  void searchRestaurant(String filter) async {
    try {
      http.Client httpClient = http.Client();
      _state = ResultState.loading;
      notifyListeners();
      final restaurants = await apiService.getRestaurantsWithFilter(httpClient, filter);
      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _restaurantFilter = restaurants;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        _message = 'Error tidak ada koneksi internet';
      } else {
        _message = 'Gagal memuat data';
      }
    }
  }
}
