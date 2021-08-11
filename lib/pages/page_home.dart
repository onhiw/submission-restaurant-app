import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_restaurant_app/bloc/restaurant-bloc/restaurant_bloc.dart';
import 'package:submission_restaurant_app/constant/constants.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/pages/page_detail.dart';
import 'package:submission_restaurant_app/utils/background_service.dart';
import 'package:submission_restaurant_app/utils/date_time_helper.dart';
import 'package:submission_restaurant_app/utils/notification_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RestaurantBloc _restaurantBloc = RestaurantBloc();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  @override
  void initState() {
    _restaurantBloc.add(GetRestaurant());
    port.listen((_) async => await _service.someTask());
    _notificationHelper.configureSelectNotificationSubject(context);
    _getShared();
    super.initState();
  }

  _getShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('notif'));
    if (prefs.getBool('notif') != null) {
      if (prefs.getBool('notif')) {
        await AndroidAlarmManager.periodic(
          Duration(hours: 24),
          1,
          BackgroundService.callback,
          startAt: DateTimeHelper.format(),
          exact: true,
          wakeup: true,
        );
      } else {
        await AndroidAlarmManager.cancel(1);
      }
    }
  }

  Future<void> onRefresh() async {
    setState(() {
      _restaurantBloc.add(GetRestaurant());
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Submission App',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/search");
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 16,
              left: 16,
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/favorite");
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.black,
                )),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 16,
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/setting");
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      body: _buildListRestaurant(),
    );
  }

  Widget _buildListRestaurant() {
    return RefreshIndicator(
      onRefresh: () => onRefresh(),
      child: BlocProvider(
        create: (context) => _restaurantBloc,
        child: BlocListener<RestaurantBloc, RestaurantState>(
          listener: (context, state) {
            if (state is RestaurantError) {
              return Fluttertoast.showToast(
                  msg: state.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white);
            }
          },
          child: BlocBuilder<RestaurantBloc, RestaurantState>(
            builder: (context, state) {
              if (state is RestaurantInitial) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RestaurantLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is RestaurantLoaded) {
                return _buildRestaurant(context, state.restaurantModel);
              } else if (state is RestaurantError) {
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
      BuildContext context, RestaurantModel restaurantModel) {
    if (restaurantModel == null) {
      return Container();
    } else if (restaurantModel.restaurants.length == 0) {
      return Container();
    }
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Restaurant",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "recommendation restaurant for you!",
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
        ListView.builder(
          itemCount: restaurantModel.restaurants.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DetailPage(
                        idRestaurant: restaurantModel.restaurants[index].id);
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: smallImage +
                            restaurantModel.restaurants[index].pictureId,
                        child: Container(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: smallImage +
                                  restaurantModel.restaurants[index].pictureId,
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
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurantModel.restaurants[index].name,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
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
                                restaurantModel.restaurants[index].city,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                restaurantModel.restaurants[index].rating
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
