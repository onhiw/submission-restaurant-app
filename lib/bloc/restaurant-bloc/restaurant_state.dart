part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantState {
  const RestaurantState();
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
  List<Object> get props => [];
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();

  List<Object> get props => null;
}

class RestaurantLoaded extends RestaurantState {
  final RestaurantModel restaurantModel;
  RestaurantLoaded(this.restaurantModel);

  List<Object> get props => [restaurantModel];
}

class RestaurantError extends RestaurantState {
  final String message;

  RestaurantError(this.message);
  List<Object> get props => [message];
}
