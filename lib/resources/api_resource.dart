import 'dart:math';

import 'package:dio/dio.dart';
import 'package:submission_restaurant_app/constant/constants.dart';
import 'package:submission_restaurant_app/models/detail_restaurant.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';

class ApiService {
  ApiService();

  Future<RestaurantModel> fetchRestaurant() async {
    final Dio _dio = Dio();
    try {
      Response _res = await _dio.get('$baseUrl/list');
      print(_res);
      final RestaurantModel restaurantModel =
          RestaurantModel.fromJson(_res.data);
      return restaurantModel;
    } catch (err) {
      print(err);
      return err;
    }
  }

  Future<SingleRestaurantModel> fetchDetailRestaurant(
      String idRestaurant) async {
    final Dio _dio = Dio();
    try {
      Response _res = await _dio.get('$baseUrl/detail/$idRestaurant');
      print(_res);
      final SingleRestaurantModel singleRestaurantModel =
          SingleRestaurantModel.fromJson(_res.data);
      return singleRestaurantModel;
    } catch (err) {
      print(err);
      return err;
    }
  }

  Future<RestaurantModel> fetchSearchRestaurant(String query) async {
    final Dio _dio = Dio();
    try {
      Response _res =
          await _dio.get('$baseUrl/search', queryParameters: {"q": query});
      print(_res);
      final RestaurantModel restaurantModel =
          RestaurantModel.fromJson(_res.data);
      return restaurantModel;
    } catch (err) {
      print(err);
      return err;
    }
  }

  Future<Restaurant> getRandomRestaurant() async {
    final Dio _dio = Dio();
    try {
      Response _res = await _dio.get('$baseUrl/list');
      print(_res);
      final random = new Random();
      List<Restaurant> listRestaurant =
          RestaurantModel.fromJson(_res.data).restaurants;
      Restaurant restaurant =
          listRestaurant[random.nextInt(listRestaurant.length)];
      return restaurant;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
