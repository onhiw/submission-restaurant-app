part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantEvent {
  const RestaurantEvent();
}

class GetRestaurant extends RestaurantEvent {
  GetRestaurant();
}
