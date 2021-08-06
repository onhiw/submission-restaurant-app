import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_restaurant_app/bloc/detail-restaurant-bloc/detail_restaurant_bloc.dart';
import 'package:submission_restaurant_app/constant/constants.dart';
import 'package:submission_restaurant_app/models/detail_restaurant.dart';

class DetailPage extends StatefulWidget {
  final String idRestaurant;
  const DetailPage({Key key, @required this.idRestaurant}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailRestaurantBloc _detailRestaurantBloc = DetailRestaurantBloc();

  @override
  void initState() {
    _detailRestaurantBloc
        .add(GetDetailRestaurant(idRestaurant: widget.idRestaurant));
    super.initState();
  }

  Future<void> onRefresh() async {
    setState(() {
      _detailRestaurantBloc
          .add(GetDetailRestaurant(idRestaurant: widget.idRestaurant));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildSingleRestaurant(),
    );
  }

  Widget _buildSingleRestaurant() {
    return RefreshIndicator(
      onRefresh: () => onRefresh(),
      child: BlocProvider(
        create: (context) => _detailRestaurantBloc,
        child: BlocListener<DetailRestaurantBloc, DetailRestaurantState>(
          listener: (context, state) {
            if (state is DetailRestaurantError) {
              return Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white);
            }
          },
          child: BlocBuilder<DetailRestaurantBloc, DetailRestaurantState>(
            builder: (context, state) {
              if (state is DetailRestaurantInitial) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DetailRestaurantLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DetailRestaurantLoaded) {
                return _buildRestaurant(context, state.singleRestaurantModel);
              } else if (state is DetailRestaurantError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/ic_failure.png',
                          width: 150,
                        ),
                        SizedBox(height: 25),
                        Container(
                          child: Text(
                            "Maaf!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: 120,
                          height: 45,
                          child: GestureDetector(
                            onTap: () {
                              onRefresh();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(45)),
                              child: Center(
                                child: Text(
                                  "Coba Lagi",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurant(
      BuildContext context, SingleRestaurantModel singleRestaurantModel) {
    if (singleRestaurantModel == null) {
      return Container();
    }
    return ListView(
      children: [
        Hero(
          tag: smallImage + singleRestaurantModel.restaurant.pictureId,
          child: Container(
            height: 250,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: largeImage + singleRestaurantModel.restaurant.pictureId,
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
                    singleRestaurantModel.restaurant.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        singleRestaurantModel.restaurant.rating.toString(),
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
                    singleRestaurantModel.restaurant.city,
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
                singleRestaurantModel.restaurant.description,
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
                    ...singleRestaurantModel.restaurant.menus.foods.map((food) {
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
                    ...singleRestaurantModel.restaurant.menus.drinks
                        .map((drink) {
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
              SizedBox(
                height: 16,
              ),
              Text(
                "Review (${singleRestaurantModel.restaurant.customerReviews.length})",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              ...singleRestaurantModel.restaurant.customerReviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        review.date,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        review.review,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
