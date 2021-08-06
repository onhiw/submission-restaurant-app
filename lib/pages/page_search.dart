import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_restaurant_app/bloc/search-restaurant-bloc/search_restaurant_bloc.dart';
import 'package:submission_restaurant_app/constant/constants.dart';
import 'package:submission_restaurant_app/models/restaurant.dart';
import 'package:submission_restaurant_app/pages/page_detail.dart';

class SearchRestaurantPage extends StatefulWidget {
  const SearchRestaurantPage({Key key}) : super(key: key);

  @override
  _SearchRestaurantPageState createState() => _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPage> {
  SearchRestaurantBloc _searchRestaurantBloc = SearchRestaurantBloc();
  TextEditingController _textEditingSearchController = TextEditingController();

  List<Restaurant> data = [];

  Future<void> _loadData(String query) async {
    setState(() {
      data.clear();
    });
    _searchRestaurantBloc.add(GetSearchRestaurant(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Search",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 5, left: 16, right: 16, top: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 55,
                    child: TextFormField(
                      cursorColor: Colors.blue,
                      autofocus: true,
                      style: GoogleFonts.poppins(),
                      controller: _textEditingSearchController,
                      onFieldSubmitted: (String str) {
                        if (str != '') {
                          setState(() {
                            str = str;
                          });
                          _loadData(str);
                        }
                      },
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[450],
                        hintText: 'Cari Restoran',
                        hintStyle: TextStyle(color: Colors.grey[150]),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffF3F3F3))),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(50.0),
        ),
      ),
      body: _buildSearchRestauarnt(),
    );
  }

  Widget _buildSearchRestauarnt() {
    return BlocProvider(
      create: (context) => _searchRestaurantBloc,
      child: BlocListener<SearchRestaurantBloc, SearchRestaurantState>(
        listener: (context, state) {
          if (state is SearchRestaurantError) {
            return Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white);
          }
        },
        child: BlocBuilder<SearchRestaurantBloc, SearchRestaurantState>(
          builder: (context, state) {
            if (state is SearchRestaurantInitial) {
              return _emptySearchInitial();
            } else if (state is SearchRestaurantLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchRestaurantLoaded) {
              if (state is SearchRestaurantLoaded) {
                data = state.restaurantModel.restaurants;
              }
              return _buildListRestaurant(context);
            } else if (state is SearchRestaurantError) {
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
                    ],
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildListRestaurant(BuildContext context) {
    if (data.length == 0) {
      return _emptySearch();
    }
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.all(16),
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailPage(idRestaurant: data[index].id);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Hero(
                    tag: smallImage + data[index].pictureId,
                    child: Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: smallImage + data[index].pictureId,
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
                        data[index].name,
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
                            data[index].city,
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
                            data[index].rating.toString(),
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
    );
  }

  Widget _emptySearchInitial() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_pindah.png',
            height: 162,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Kamu bisa lakukan pencarian di kolom pencarian',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Silahkan lakukan pencarian tempat favorite kamu di kolom pencarian',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _emptySearch() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_pindah.png',
            height: 162,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Tidak dapat ditemukan hasil untuk "${_textEditingSearchController.text}"',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Silahkan lakukan pencarian kembali tempat favorite kamu di kolom pencarian',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
