import 'package:projeto6_agenda_contatos/pages/newContact.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class Contact {
  Contact(
      {required String this.id,
      required String this.name,
      required String this.email,
      required String this.phone,
      this.img});

  String? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Map<dynamic, dynamic> toMap() {
    Map<dynamic, dynamic> newContact = {};
    if (id != null) {
      newContact[idColumn] = id;
    }
    newContact[nameColumn] = name;
    newContact[emailColumn] = email;
    newContact[phoneColumn] = phone;
    newContact[imgColumn] = img;
    return newContact;
  }
}
