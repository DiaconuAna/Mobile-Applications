import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import '../model/movie.dart';

import 'dart:developer';

class MovieDB {
  static final MovieDB instance = MovieDB._init();
  static Database? _db;

  MovieDB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('tip.db');
    return _db!;
  }

  Future<Database> _initDB(String path) async {
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute(''' 
    CREATE TABLE $movieTable (${MovieFields.id} $idType, 
                             ${MovieFields.name} $textType,
                             ${MovieFields.description} $textType,
                             ${MovieFields.director} $textType,
                             ${MovieFields.genre} $textType,
                             ${MovieFields.year} $intType
                             )
      ''');

    await db.execute(''' 
      CREATE TABLE $genreTable ('_id' $idType,
      'genre' $textType
      )
      ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // genres

  Future<String> addGenre(String genre) async {
    log("DB: add genre ${genre}");
    Map<String, Object?> jsonGenre = {"genre": genre};
    final db = await instance.database;
    final id = await db.insert(genreTable, jsonGenre);
    return genre;
  }

  void deleteAllGenres() async {
    // log("DB: delete all genres");
    final db = await instance.database;
    db.rawDelete('delete from genres');
  }

  Future<List<String>> getGenres() async {
    log("DB: get genres");
    final db = await instance.database;
    final result = await db.query(genreTable);
    // print("CATEGORIES: " + result.toString());
    return result.map((json) => json['genre'].toString()).toList();
  }

  // movies

  Future<Movie> addMovie(Movie movie) async {
    final db = await instance.database;
    final id = await db.insert(movieTable, movie.toJson());
    return movie.copy(id: id);
  }

  Future<List<Movie>> getByGenre(String genre) async {
    log("DB: get movies for genre $genre");
    final db = await instance.database;

    final maps = await db.query(movieTable,
        columns: MovieFields.values,
        where: '${MovieFields.genre} = ?',
        whereArgs: [genre]);

    if (maps.isNotEmpty) {
      log("DB: get movies for genre $genre returned ${maps.length} results");
      return maps.map((e) => Movie.fromJson(e)).toList();
    } else {
      log("DB: get movies for genre $genre failed");
      throw Exception('No movies for the given genre');
    }
  }

  void deleteAllMoviesByGenre(String genre) async {
    // log("DB: delete all genres");
    final db = await instance.database;
    db.rawDelete('delete from movies where genre = ?', [genre]);
  }

  Future<int> deleteMovie(int id) async {
    log("DB: delete movie with id $id");
    final db = await instance.database;

    return await db
        .delete(movieTable, where: '${MovieFields.id} = ?', whereArgs: [id]);
  }
}
