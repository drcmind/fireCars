import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_cars/models/carModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  String? userID, carID;
  DatabaseService({this.userID, this.carID});
  // Déclaraction et Initialisation
  CollectionReference _cars = FirebaseFirestore.instance.collection('cars');
  FirebaseStorage _storage = FirebaseStorage.instance;

  // upload de l'image vers Firebase Storage
  Future<String> uploadFile(File file, XFile fileWeb) async {
    Reference reference = _storage.ref().child('cars/${DateTime.now()}.png');
    Uint8List imageTosave = await fileWeb.readAsBytes();
    SettableMetadata metaData = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = kIsWeb
        ? reference.putData(imageTosave, metaData)
        : reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  // ajout de la voiture dans la BDD
  void addCar(Car car) {
    _cars.add({
      "carName": car.carName,
      "carUrlImg": car.carUrlImg,
      "carUserID": car.carUserID,
      "carUserName": car.carUserName,
      "carTimestamp": FieldValue.serverTimestamp(),
      "carFavoriteCount": 0,
    });
  }

  // suppression de la voiture
  Future<void> deleteCar(String carID) => _cars.doc(carID).delete();

  // Récuperation de toutes les voitures en temps réel
  Stream<List<Car>> get cars {
    Query queryCars = _cars.orderBy('carTimestamp', descending: true);
    return queryCars.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Car(
          carID: doc.id,
          carName: doc.get('carName'),
          carUrlImg: doc.get('carUrlImg'),
          carUserID: doc.get('carUserID'),
          carUserName: doc.get('carUserName'),
          carFavoriteCount: doc.get('carFavoriteCount'),
          carTimestamp: doc.get('carTimestamp'),
        );
      }).toList();
    });
  }

  // ajout de la voiture favoris dans une sous-collection
  void addFavoriteCar(Car car, String userID) async {
    final carDocRef = _cars.doc(car.carID);
    final favoritedBy = carDocRef.collection('favoritedBy');
    int carFavoriteCount = car.carFavoriteCount!;
    int increaseCount = carFavoriteCount += 1;
    favoritedBy.doc(userID).set({
      "carName": car.carName,
      "carUrlImg": car.carUrlImg,
      "carUserID": car.carUserID,
      "carUserName": car.carUserName,
      "carTimestamp": car.carTimestamp,
      "carFavoriteCount": increaseCount,
    });
    carDocRef.update({"carFavoriteCount": increaseCount});
  }

  // rétirer la voiture de la liste des favoris
  void removeFavoriteCar(Car car, String userID) {
    final carDocRef = _cars.doc(car.carID);
    final favoritedBy = carDocRef.collection('favoritedBy');
    int carFavoriteCount = car.carFavoriteCount!;
    int decreaseCount = carFavoriteCount -= 1;
    carDocRef.update({"carFavoriteCount": decreaseCount});
    favoritedBy.doc(userID).delete();
  }

  // Récuperation des voitures favoris de l'utilisateur en temps réel
  Stream<Car> get myFavoriteCar {
    final favoritedBy = _cars.doc(carID).collection('favoritedBy');
    return favoritedBy.doc(userID).snapshots().map((doc) {
      return Car(
        carID: doc.id,
        carName: doc.get('carName'),
        carUrlImg: doc.get('carUrlImg'),
        carUserID: doc.get('carUserID'),
        carUserName: doc.get('carUserName'),
        carFavoriteCount: doc.get('carFavoriteCount'),
        carTimestamp: doc.get('carTimestamp'),
      );
    });
  }

  Future<Car> singleCar(String carID) async {
    final doc = await _cars.doc(carID).get();
    return Car(
      carID: carID,
      carName: doc.get('carName'),
      carUrlImg: doc.get('carUrlImg'),
      carUserID: doc.get('carUserID'),
      carUserName: doc.get('carUserName'),
      carFavoriteCount: doc.get('carFavoriteCount'),
      carTimestamp: doc.get('carTimestamp'),
    );
  }
}
