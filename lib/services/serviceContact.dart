import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:projeto6_agenda_contatos/models/modelContact.dart';

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

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;

    //Save contact
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact?> getContact(int idContact) async {
    Database dbContact = await db;

    //Get contact
    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [idContact]);

    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int idContact) async {
    Database dbContact = await db;

    //Delete contact
    return await dbContact
        .delete(contactTable, where: "$idColumn = ?", whereArgs: [idContact]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;

    //updateContact
    return await dbContact.update(contactTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAllContacts() async {
    Database dbContact = await db;

    //Return list of contacts
    List mapList = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> contactsMap = [];
    for (Map m in mapList) {
      contactsMap.add(Contact.fromMap(m));
    }
    return contactsMap;
  }
}
