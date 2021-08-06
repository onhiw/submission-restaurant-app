part of 'detail_restaurant_bloc.dart';

@immutable
abstract class DetailRestaurantState {
  const DetailRestaurantState();
}

class DetailRestaurantInitial extends DetailRestaurantState {
  const DetailRestaurantInitial();
  List<Object> get props => [];
}

class DetailRestaurantLoading extends DetailRestaurantState {
  const DetailRestaurantLoading();

  List<Object> get props => null;
}

class DetailRestaurantLoaded extends DetailRestaurantState {
  final SingleRestaurantModel singleRestaurantModel;
  DetailRestaurantLoaded(this.singleRestaurantModel);

  List<Object> get props => [singleRestaurantModel];
}

class DetailRestaurantError extends DetailRestaurantState {
  final String message;

  DetailRestaurantError(this.message);
  List<Object> get props => [message];
}
