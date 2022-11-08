import 'package:projeto6_agenda_contatos/pages/newContact.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class Contact {
  Contact(
      {int? this.id,
      required String this.name,
      required String this.email,
      required String this.phone,
      this.img});

  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> newContact = {};
    if (id != null) {
      newContact[idColumn] = id;
    }
    newContact[nameColumn] = name;
    newContact[emailColumn] = email;
    newContact[phoneColumn] = phone;
    newContact[imgColumn] = img;
    return newContact;
  }

  Contact.fromMap(Map mapContact) {
    id = mapContact[idColumn];
    name = mapContact[nameColumn];
    email = mapContact[emailColumn];
    phone = mapContact[phoneColumn];
    img = mapContact[imgColumn];
  }
}
