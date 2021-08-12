import 'dart:io';

import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CarDialog {
  User? user;
  CarDialog({this.user});
  void showCarDialog(BuildContext context, ImageSource source) async {
    XFile? _pickedFile = await ImagePicker().pickImage(source: source);
    File _file = File(_pickedFile!.path);
    String _carName = '';
    String _formError = 'Veillez fournir le nom de la voiture';
    final _keyForm = GlobalKey<FormState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: FileImage(_file), fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Form(
                    key: _keyForm,
                    child: TextFormField(
                      maxLength: 20,
                      onChanged: (value) => _carName = value,
                      validator: (value) => _carName == '' ? _formError : null,
                      decoration: InputDecoration(
                          labelText: 'Nom de la voiture',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(children: [
                      TextButton(
                          child: Text("ANNULER"),
                          onPressed: () => Navigator.of(context).pop()),
                      ElevatedButton(
                          child: Text('PUBLIER'),
                          onPressed: () => onSubmit(
                              context, _keyForm, _file, _carName, user))
                    ]),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  void onSubmit(_, keyForm, file, carName, user) async {
    if (keyForm.currentState!.validate()) {
      Navigator.of(_).pop();
      showNotification(_, 'Chargement...');
      DatabaseService _db = DatabaseService();
      String _carUrlImg = await _db.uploadFile(file);
      _db.addCar(Car(
          carName: carName,
          carUrlImg: _carUrlImg,
          carUserID: user!.uid,
          carUserName: user!.displayName));
    }
  }
}
