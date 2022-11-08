import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projeto6_agenda_contatos/pages/newContact.dart';
import 'package:projeto6_agenda_contatos/services/serviceContact.dart';
import 'package:string_scanner/string_scanner.dart';
import 'package:projeto6_agenda_contatos/models/modelContact.dart';

class HomeContactsPage extends StatefulWidget {
  const HomeContactsPage({super.key});

  @override
  State<HomeContactsPage> createState() => _HomeContactsPageState();
}

class _HomeContactsPageState extends State<HomeContactsPage> {
  ServiceContact contactService = ServiceContact();

  //Novo
  List<Contact> _listContact = [];
  Contact? backupContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactService.getAllContacts().then((value) {
      setState(() {
        _listContact = value;
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
            itemCount: _listContact.length,
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
                  backupContact = _listContact[index];
                  setState(() {
                    setState(() async {
                      contactService.deleteContact(_listContact[index].id!);
                      _listContact = await contactService.getAllContacts();
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.black54,
                      content: Text(
                          "O contato de ${_listContact[index].name} foi removido com sucesso"),
                      action: SnackBarAction(
                        label: "Desfazer",
                        onPressed: () {
                          setState(() async {
                            contactService.saveContact(backupContact!);
                            _listContact =
                                await contactService.getAllContacts();
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

  void updateContact(
      String name, String email, String tel, String? pathphoto, int index) {
    setState(() async {
      await contactService.updateContact(Contact(
          id: _listContact[index].id,
          name: name,
          email: email,
          phone: tel,
          img: pathphoto));
      _listContact = await contactService.getAllContacts();
    });
  }

  void _addContact(
      String name, String email, String tel, String? pathphoto) async {
    contactService.saveContact(
        Contact(name: name, email: email, phone: tel, img: pathphoto));
    setState(() async {
      _listContact = await contactService.getAllContacts();
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
                      contact: _listContact[index],
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
              _listContact[index].img == null
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
                              image: FileImage(File(_listContact[index].img!)),
                              fit: BoxFit.fill)),
                    ),
              const SizedBox(
                width: 20,
              ),
              Text(
                _listContact[index].name!,
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
