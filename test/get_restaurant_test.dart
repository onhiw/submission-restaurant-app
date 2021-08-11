import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';

class ListRestaurant extends Mock implements ApiService {}

void main() {
  var apiService = ApiService();
  final restaurantModel = RestaurantModel();

  setUp(() {
    apiService = ListRestaurant();
  });

  test('Mencoba mendapatkan data restaurant', () async {
    when(apiService.fetchRestaurant()).thenAnswer((_) async => restaurantModel);
    final result = await apiService.fetchRestaurant();
    expect(result, restaurantModel);

    verify(apiService.fetchRestaurant());
    verifyNoMoreInteractions(apiService);
  });
}
