import 'dart:io';

///sqflite
///path_provider
///path

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  ///private constructor
  DBHelper._();

  ///Singleton
  static DBHelper getInstance() => DBHelper._();

  /// open DB
  /// create DB
  /// queries

  Database? mDB;
  String dbName = "noteDb.db";
  String tableName = "note";
  String column_note_id = "note_id";
  String column_note_title = "note_title";
  String column_note_desc = "note_desc";


  ///initDB
  Future<Database> initDB() async{
    /*if(mDB==null){
      //openDB and initialize mDB;
      mDB = await openDB();
    } */

    mDB ??= await openDB();
    return mDB!;
  }


  ///openDB
  Future<Database> openDB() async{
    ///data/data/www.facebook.katana/databases/fb.db
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, dbName);

    return await openDatabase(dbPath, version: 1, onCreate: (db, version){
      /// create the tables
      /// integer, text, real, blob
      db.execute("create table $tableName ( $column_note_id integer primary key autoincrement, $column_note_title text, $column_note_desc text )");
    });

  }


  ///queries
  Future<bool> insertNote({required String title, required String desc}) async{
    var db = await initDB();

    int rowsEffected = await db.insert(tableName, {
      column_note_title : title,
      column_note_desc : desc,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async{
    var db = await initDB();
    return await db.query(tableName);
  }

  ///update
  ///delete

}