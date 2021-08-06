import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial());

  @override
  Stream<RestaurantState> mapEventToState(
    RestaurantEvent event,
  ) async* {
    if (event is GetRestaurant) {
      ApiService _apiService = ApiService();
      try {
        yield RestaurantLoading();
        final restaurantData = await _apiService.fetchRestaurant();
        yield RestaurantLoaded(restaurantData);
        if (restaurantData == null) {
          yield RestaurantError(
              'Terjadi kesalahan saat terhubung dengan server');
        }
      } catch (err) {
        yield RestaurantError('Terjadi kesalahan saat terhubung dengan server');
      }
    }
  }
}
