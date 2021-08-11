import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:submission_restaurant_app/models/detail_restaurant.dart';
import 'package:submission_restaurant_app/resources/api_resource.dart';

class ListRestaurant extends Mock implements ApiService {}

void main() {
  var apiService = ApiService();
  final singleRestaurantModel = SingleRestaurantModel();

  setUp(() {
    apiService = ListRestaurant();
  });

  test('Mencoba mendapatkan detail restaurant', () async {
    when(apiService.fetchDetailRestaurant("8maika7giinkfw1e867"))
        .thenAnswer((_) async => singleRestaurantModel);

    final result =
        await apiService.fetchDetailRestaurant("8maika7giinkfw1e867");
    expect(result, singleRestaurantModel);
    verify(apiService.fetchDetailRestaurant("8maika7giinkfw1e867"));
    verifyNoMoreInteractions(apiService);
  });
}
