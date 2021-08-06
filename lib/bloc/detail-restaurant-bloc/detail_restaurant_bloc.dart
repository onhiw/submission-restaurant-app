import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:submission_restaurant_app/models/detail_restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';

part 'detail_restaurant_event.dart';
part 'detail_restaurant_state.dart';

class DetailRestaurantBloc
    extends Bloc<DetailRestaurantEvent, DetailRestaurantState> {
  DetailRestaurantBloc() : super(DetailRestaurantInitial());

  @override
  Stream<DetailRestaurantState> mapEventToState(
    DetailRestaurantEvent event,
  ) async* {
    if (event is GetDetailRestaurant) {
      ApiService _apiService = ApiService();
      try {
        yield DetailRestaurantLoading();
        final singleRestaurant =
            await _apiService.fetchDetailRestaurant(event.idRestaurant);
        yield DetailRestaurantLoaded(singleRestaurant);
        if (singleRestaurant == null) {
          yield DetailRestaurantError(
              'Terjadi kesalahan saat terhubung dengan server');
        }
      } catch (err) {
        yield DetailRestaurantError(
            'Terjadi kesalahan saat terhubung dengan server');
      }
    }
  }
}
