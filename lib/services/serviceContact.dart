import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Columns -> id || name || email || phone || img path
final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ServiceContact {
  static final ServiceContact _instance = ServiceContact();

  factory ServiceContact() => _instance;

  ServiceContact.internal();

  Database? _db;

  Future get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await init_db();
    }
  }

  Future<Database> init_db() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "contactsNew.db");
    return await openDatabase(path, version: 1, onCreate: ((db, version) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT,)");
    }));
  }
}
