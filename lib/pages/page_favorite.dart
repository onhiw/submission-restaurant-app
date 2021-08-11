import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:submission_restaurant_app/constant/constants.dart';
import 'package:submission_restaurant_app/models/favorite.dart';
import 'package:submission_restaurant_app/pages/page_detail.dart';
import 'package:submission_restaurant_app/utils/db_helper.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Favorite> items = [];

  _deleteFavorite(String id) {
    var dbHelper = DBHelper();
    setState(() {
      dbHelper.deleteFavorite(id);
    });
  }

  Future<List<Favorite>> _getDataFavorite() async {
    var dbHelper = DBHelper();
    await dbHelper.getAllFavorite().then((value) {
      items = value;
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Favorite",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: _getAllDataFavorite(),
    );
  }

  _getAllDataFavorite() {
    return FutureBuilder(
        future: _getDataFavorite(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<Favorite> favorite = snapshot.data;
            if (favorite.length == 0) {
              return Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/empty_search.png',
                        height: 162,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Anda belum menambahkan favorite',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorite Anda',
                        style: TextStyle(
                            // fontFamily: "Caveat",
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                            // color: kKepasarTeal
                            ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var dbHelper = DBHelper();
                          setState(() {
                            dbHelper.deleteAll();
                          });
                        },
                        child: Text(
                          'Hapus Semua',
                          style: TextStyle(
                              // fontFamily: "Caveat",
                              fontSize: 14.0,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.only(left: 16, right: 16),
                    itemCount: favorite.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(top: 8, bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailPage(
                                  idRestaurant: favorite[index].idRestaurant);
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Hero(
                                  tag: smallImage + favorite[index].images,
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            smallImage + favorite[index].images,
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
                                        errorWidget: (context, url, error) =>
                                            Center(
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
                                      favorite[index].name,
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
                                          favorite[index].city,
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
                                          favorite[index].rating.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _deleteFavorite(
                                          favorite[index].idRestaurant);
                                      Fluttertoast.showToast(
                                          msg: "Berhasil menghapus favorite",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
