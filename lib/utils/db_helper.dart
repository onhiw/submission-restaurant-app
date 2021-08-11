import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:submission_restaurant_app/models/favorite.dart';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  factory DBHelper() => _instance;

  static Database _db;
  static const String _tblFavorite = 'favorites';

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favorite.db");
    var theDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $_tblFavorite ( 
          idRestaurant TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          city TEXT NOT NULL,
          images TEXT NOT NULL,
          rating REAL NOT NULL
          )
          ''');
    });
    return theDb;
  }

  DBHelper.internal();

  Future<void> insert(Favorite favorite) async {
    var dbClient = await db;

    await dbClient.insert('$_tblFavorite', favorite.toMap());
  }

  Future<Favorite> getFavorite(String idRestaurant) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('$_tblFavorite',
        columns: [
          'idRestaurant',
          'name',
          'city',
          'images',
          'rating',
        ],
        where: 'idRestaurant = ?',
        whereArgs: [idRestaurant]);
    if (maps.length > 0) {
      return Favorite.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteFavorite(String idRestaurant) async {
    var dbClient = await db;
    return await dbClient.delete('$_tblFavorite',
        where: 'idRestaurant = ?', whereArgs: [idRestaurant]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('Delete from $_tblFavorite');
  }

  Future<List> getAllFavorite() async {
    List<Favorite> user = [];
    var dbClient = await db;
    List<Map> maps = await dbClient.query('$_tblFavorite', columns: [
      'idRestaurant',
      'name',
      'city',
      'images',
      'rating',
    ]);
    if (maps.length > 0) {
      maps.forEach((f) {
        user.add(Favorite.fromMap(f));
      });
    }
    return user;
  }
}
