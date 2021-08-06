part of 'detail_restaurant_bloc.dart';

@immutable
abstract class DetailRestaurantEvent {
  const DetailRestaurantEvent();
}

class GetDetailRestaurant extends DetailRestaurantEvent {
  final String idRestaurant;

  GetDetailRestaurant({this.idRestaurant});
}
