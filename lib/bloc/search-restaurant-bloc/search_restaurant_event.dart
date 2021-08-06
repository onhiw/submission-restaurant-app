part of 'search_restaurant_bloc.dart';

@immutable
abstract class SearchRestaurantEvent {
  const SearchRestaurantEvent();
}

class GetSearchRestaurant extends SearchRestaurantEvent {
  final String query;

  GetSearchRestaurant({this.query});
}
