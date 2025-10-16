import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:themoviedb/feature/watchlist/data/models/watchlist_model.dart';

class WatchlistLocalDataSource {
  static const String tableName = 'watchlist';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'watchlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            voteAverage REAL,
            overview TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertWatchlist(WatchlistModel movie) async {
    final db = await database;
    print('apa yang di insert? $movie');
    await db.insert(
      tableName,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeWatchlist(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<WatchlistModel>> getWatchlist() async {
    final db = await database;
    final result = await db.query(tableName);
    return result.map((json) => WatchlistModel.fromMap(json)).toList();
  }

  Future<bool> isAddedToWatchlist(int id) async {
    final db = await database;
    final result = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
