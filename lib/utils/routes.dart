import 'package:submission_restaurant_app/pages/page_favorite.dart';
import 'package:submission_restaurant_app/pages/page_home.dart';
import 'package:submission_restaurant_app/pages/page_search.dart';
import 'package:submission_restaurant_app/pages/page_setting.dart';

final appRoutes = {
  '/': (context) => HomePage(),
  '/search': (context) => SearchRestaurantPage(),
  '/favorite': (context) => FavoritePage(),
  '/setting': (context) => SettingPage(),
};
