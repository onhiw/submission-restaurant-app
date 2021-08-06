part of 'search_restaurant_bloc.dart';

@immutable
abstract class SearchRestaurantState {
  const SearchRestaurantState();
}

class SearchRestaurantInitial extends SearchRestaurantState {
  const SearchRestaurantInitial();
  List<Object> get props => [];
}

class SearchRestaurantLoading extends SearchRestaurantState {
  const SearchRestaurantLoading();

  List<Object> get props => null;
}

class SearchRestaurantLoaded extends SearchRestaurantState {
  final RestaurantModel restaurantModel;
  SearchRestaurantLoaded(this.restaurantModel);

  List<Object> get props => [restaurantModel];
}

class SearchRestaurantError extends SearchRestaurantState {
  final String message;

  SearchRestaurantError(this.message);
  List<Object> get props => [message];
}
