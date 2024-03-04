import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';
import 'package:http/http.dart' as http;

enum ResultState { loading, noData, hasData, error }
 
class RestaurantDetailsProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailsProvider({required this.apiService, required this.id}) {
    _fetchRestaurantDetails();
  }
 
  late RestaurantDetails _restaurantDetails;
  late ResultState _state;
  String _message = '';
 
  String get message => _message;
 
  RestaurantDetails get result => _restaurantDetails;
 
  ResultState get state => _state;
 
  Future<dynamic> _fetchRestaurantDetails() async {
    try {
      http.Client httpClient = http.Client();
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetails(httpClient, id);
      _state = ResultState.hasData;
      notifyListeners();
      return _restaurantDetails = restaurant;
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
      final restaurant = await apiService.getRestaurantDetails(httpClient, id);
      _state = ResultState.hasData;
      notifyListeners();
      _restaurantDetails = restaurant;
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
