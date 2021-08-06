import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';

part 'search_restaurant_event.dart';
part 'search_restaurant_state.dart';

class SearchRestaurantBloc
    extends Bloc<SearchRestaurantEvent, SearchRestaurantState> {
  SearchRestaurantBloc() : super(SearchRestaurantInitial());

  @override
  Stream<SearchRestaurantState> mapEventToState(
    SearchRestaurantEvent event,
  ) async* {
    if (event is GetSearchRestaurant) {
      ApiService _apiService = ApiService();
      try {
        yield SearchRestaurantLoading();
        final restaurantData =
            await _apiService.fetchSearchRestaurant(event.query);
        yield SearchRestaurantLoaded(restaurantData);
        if (restaurantData == null) {
          yield SearchRestaurantError(
              'Terjadi kesalahan saat terhubung dengan server');
        }
      } catch (err) {
        yield SearchRestaurantError(
            'Terjadi kesalahan saat terhubung dengan server');
      }
    }
  }
}
