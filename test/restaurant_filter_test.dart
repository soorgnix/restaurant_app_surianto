import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_details.dart';
import 'package:restaurant_app/data/model/restaurant_filter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'restaurant_filter_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('ApiService Test', () {
    test('test get restaurants list', () async {
      final client = MockClient();
      ApiService apiService = ApiService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/search?q=')))
          .thenAnswer((_) async => http.Response('{"error": false,"founded": 1,"restaurants": [{"id": "fnfn8mytkpmkfw1e867","name": "Makan mudah","description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...","pictureId": "22","city": "Medan","rating": 3.7}]}', 200));

      expect(await apiService.getRestaurantsWithFilter(client, ''), isA<RestaurantFilter>());
    });

    test('test get restaurants details', () async {
      final client = MockClient();
      ApiService apiService = ApiService();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"}]},"rating":4.2,"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"}]}}', 200));

      expect(await apiService.getRestaurantDetails(client, 'rqdv5juczeskfw1e867'), isA<RestaurantDetails>());
    });

  });
}