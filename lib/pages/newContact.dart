import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto6_agenda_contatos/pages/homeContactsPage.dart';

class NewContact extends StatefulWidget {
  NewContact(
      {Key? key,
      required this.addContact,
      this.contact,
      this.indexUpdateContact,
      this.updateContact})
      : super(key: key);

  String TitleContact = '';
  final int? indexUpdateContact;

  final Function? updateContact;
  final Function addContact;
  Map<String, dynamic>? contact;

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool shouldPop = true;
  String? _Myimage;
  bool buttonActivated = true;

  Future<void> _getImageCamera() async {
    await _picker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        _Myimage = value!.path;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!["name"];
      lastnameController.text = widget.contact!["lastname"];
      telephoneController.text = widget.contact!["tel"];
      _Myimage = widget.contact!["photo"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _onBackPressed();
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            widget.TitleContact,
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
          child: Column(children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _getImageCamera();
                });
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: _Myimage != null
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: FileImage(File(_Myimage!)),
                        )
                      : null,
                ),
                child: _Myimage == null
                    ? const Icon(
                        Icons.person,
                        size: 120,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
            formTextField(nameController, "Nome", "Digite seu nome!"),
            formTextField(
                lastnameController, "Sobrenome", "Digite seu sobrenome!"),
            formTextField(telephoneController, "Telefone", "Seu telefone"),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: TextButton(
                      onPressed: () {
                        buttonActivated = true;
                        if (buttonActivated == true &&
                            nameController.text.isNotEmpty &&
                            lastnameController.text.isNotEmpty &&
                            telephoneController.text.isNotEmpty) {
                          if (widget.contact == null) {
                            widget.addContact(
                                nameController.text,
                                lastnameController.text,
                                telephoneController.text,
                                _Myimage);
                          } else {
                            widget.updateContact!(
                                nameController.text,
                                lastnameController.text,
                                telephoneController.text,
                                _Myimage,
                                widget.indexUpdateContact);
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const HomeContactsPage())),
                              (Route<dynamic> route) => false);
                        } else {
                          buttonActivated = false;
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.contact != null
                              ? "Atualizar Contato"
                              : "Salvar",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      )),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<dynamic> _onBackPressed() {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: const Text("Você tem certeza ?"),
              content:
                  const Text("O contato ou modificações não serão salvas ok ?"),
              actions: [
                TextButton(
                    onPressed: () {
                      shouldPop = false;
                      Navigator.of(context).pop(false);
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      shouldPop = true;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeContactsPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            )));
  }

  Widget formTextField(TextEditingController c, String label, String hintText) {
    return TextField(
      onChanged: c == nameController
          ? (value) {
              setState(() {
                widget.TitleContact = value;
              });
            }
          : null,
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        errorText: buttonActivated && c.text.isNotEmpty ? null : hintText,
      ),
    );
  }
}