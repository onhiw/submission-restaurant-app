import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';

class DetailPage extends StatefulWidget {
  final Restaurant restaurant;
  const DetailPage({Key key, @required this.restaurant}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: widget.restaurant.pictureId,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )),
              errorWidget: (context, url, error) => Center(
                  child: Image.asset(
                "assets/default_image.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.restaurant.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.restaurant.city,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  widget.restaurant.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Daftar Menu",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Anda dapat memilih daftar menu favorit",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Makanan",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.restaurant.menus.foods.map((food) {
                        return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                food.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                      }).toList()
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Minuman",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.restaurant.menus.drinks.map((drink) {
                        return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              drink.name,
                              style: TextStyle(color: Colors.white),
                            ));
                      }).toList()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
