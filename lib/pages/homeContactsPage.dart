import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto6_agenda_contatos/pages/newContact.dart';
import 'package:string_scanner/string_scanner.dart';

class HomeContactsPage extends StatefulWidget {
  const HomeContactsPage({super.key});

  @override
  State<HomeContactsPage> createState() => _HomeContactsPageState();
}

class _HomeContactsPageState extends State<HomeContactsPage> {
  List<dynamic> _contactsList = [];
  Map<String, dynamic>? contactBackup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readData().then((data) {
      setState(() {
        _contactsList = json.decode(data!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Contatos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 25,
              ))
        ],
      ),
      //Corpo do meu scaffold
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _contactsList.length,
            itemBuilder: ((context, index) {
              return Dismissible(
                key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
                background: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  contactBackup = _contactsList[index];
                  setState(() {
                    _contactsList.removeAt(index);
                    _saveData();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.black54,
                      content: Text(
                          "O contato de ${contactBackup!["name"]} foi removido com sucesso"),
                      action: SnackBarAction(
                        label: "Desfazer",
                        onPressed: () {
                          setState(() {
                            _contactsList.insert(index, contactBackup);
                            _saveData();
                          });
                        },
                      ),
                    ),
                  );
                },
                direction: DismissDirection.startToEnd,
                child: listContacts(index),
              );
            }),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewContact(addContact: _addContact)));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  //Funções de manipulação de dados
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_contactsList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void updateContact(
      String name, String lastname, String tel, String? pathphoto, int index) {
    Map<String, dynamic> newContact = {};
    newContact["name"] = name;
    newContact["lastname"] = lastname;
    newContact["tel"] = tel;
    newContact["photo"] = pathphoto;
    setState(() {
      _contactsList[index] = newContact;
      _saveData();
    });
  }

  void _addContact(
      String name, String lastname, String tel, String? pathphoto) {
    Map<String, dynamic> newContact = {};
    newContact["name"] = name;
    newContact["lastname"] = lastname;
    newContact["tel"] = tel;
    newContact["photo"] = pathphoto;
    setState(() {
      _contactsList.add(newContact);
      _saveData();
    });
  }

  Widget listContacts(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewContact(
                      indexUpdateContact: index,
                      updateContact: updateContact,
                      addContact: _addContact,
                      contact: _contactsList[index],
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              _contactsList[index]["photo"] == null
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(0, 255, 248, 225)),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          image: DecorationImage(
                              image: FileImage(
                                  File(_contactsList[index]["photo"])),
                              fit: BoxFit.fill)),
                    ),
              const SizedBox(
                width: 20,
              ),
              Text(
                _contactsList[index]["name"],
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
