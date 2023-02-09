import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import '../model/entry.dart';

import 'dart:developer';

class FitnessDB {
  static final FitnessDB instance = FitnessDB._init();
  static Database? _db;

  FitnessDB._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('fitness.db');
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
    CREATE TABLE $fitnessTable (${EntryFields.id} $idType, 
                             ${EntryFields.date} $textType,
                             ${EntryFields.type} $textType,
                             ${EntryFields.duration} $intType,
                             ${EntryFields.distance} $intType,
                             ${EntryFields.calories} $intType,
                             ${EntryFields.rate} $intType
                             )
      ''');

    await db.execute(''' 
      CREATE TABLE $dateTable ('_id' $idType,
      'date' $textType
      )
      ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // dates

  Future<String> addDate(String date) async {
    log("DB: add date ${date}");
    Map<String, Object?> jsonDate = {"date": date};
    final db = await instance.database;
    final id = await db.insert(dateTable, jsonDate);
    return date;
  }

  void deleteAllDates() async {
    // log("DB: delete all dates");
    final db = await instance.database;
    db.rawDelete('delete from dates');
  }

  Future<List<String>> getDates() async {
    log("DB: get dates");
    final db = await instance.database;
    final result = await db.query(dateTable);
    return result.map((json) => json['date'].toString()).toList();
  }

  // entries

  Future<Entry> addEntry(Entry entry) async {
    final db = await instance.database;
    final id = await db.insert(fitnessTable, entry.toJson());
    return entry.copy(id: id);
  }

  Future<int> deleteEntry(int id) async {
    log("DB: delete entry with id $id");
    final db = await instance.database;

    return await db
        .delete(fitnessTable, where: '${EntryFields.id} = ?', whereArgs: [id]);
  }

  Future<List<Entry>> getBydate(String date) async {
    log("DB: get entries for date $date");
    final db = await instance.database;

    final maps = await db.query(fitnessTable,
        columns: EntryFields.values,
        where: '${EntryFields.date} = ?',
        whereArgs: [date]);

    if (maps.isNotEmpty) {
      log("DB: get entries for date $date returned ${maps.length} results");
      return maps.map((e) => Entry.fromJson(e)).toList();
    } else {
      log("DB: get entries for date $date failed");
      throw Exception('No entries for the given date');
    }
  }

  void deleteAllEntriesBydate(String date) async {
    // log("DB: delete all dates");
    final db = await instance.database;
    db.rawDelete('delete from entries where date = ?', [date]);
  }
}
