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

  Future<RestaurantModel> addReviewRestaurant(
      String id, String name, String review) async {
    final Dio _dio = Dio();
    try {
      Response _res = await _dio.post('$baseUrl/review',
          data: {"id": id, "name": name, "review": review},
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              headers: {"X-Auth-Token": "12345"}));
      print(_res);
      final RestaurantModel restaurantModel =
          RestaurantModel.fromJson(_res.data);
      return restaurantModel;
    } catch (err) {
      print(err);
      return err;
    }
  }
}
