class Favorite {
  String idRestaurant;
  String name;
  String city;
  String images;
  double rating;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'city': city,
      'images': images,
      'rating': rating,
    };
    if (idRestaurant != null) {
      map['idRestaurant'] = idRestaurant;
    }
    return map;
  }

  Favorite();

  Favorite.fromMap(Map<String, dynamic> map) {
    idRestaurant = map['idRestaurant'];
    name = map['name'];
    city = map['city'];
    images = map['images'];
    rating = map['rating'];
  }
}
