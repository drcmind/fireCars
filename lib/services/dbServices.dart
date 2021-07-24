import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_cars/models/carModel.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  String? userID;
  DatabaseService({this.userID});
  // Déclaraction et Initialisation
  CollectionReference _cars = FirebaseFirestore.instance.collection('cars');
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  FirebaseStorage _storage = FirebaseStorage.instance;

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

  // upload de l'image vers Firebase Storage
  Future<String> uploadFile(file) async {
    Reference reference = _storage.ref().child('cars/${DateTime.now()}.png');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

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

  // vérification si la voiture fait partie des favoris de l'utilisateur
  Future<bool> isMyFavoriteCars(String carID, String userID) async {
    final myFavoriteCars = _users.doc(userID).collection('myFavoriteCars');
    final docSnapshot = await myFavoriteCars.doc(carID).get();
    return docSnapshot.exists;
  }

  // ajout de la voiture favoris dans une sous-collection
  void addFavoriteCar(Car car, String userID, int carFavoriteCount) {
    final carDocRef = _cars.doc(car.carID);
    final myFavoriteCars = _users.doc(userID).collection('myFavoriteCars');
    carDocRef.update({"carFavoriteCount": carFavoriteCount});
    myFavoriteCars.doc(car.carID).set({
      "carName": car.carName,
      "carUrlImg": car.carUrlImg,
      "carUserID": car.carUserID,
      "carUserName": car.carUserName,
      "carTimestamp": car.carTimestamp,
      "carFavoriteCount": carFavoriteCount
    });
  }

  // rétirer la voiture de la liste des favoris
  void removeFavoriteCar(Car car, String userID, int carFavoriteCount) {
    final carDocRef = _cars.doc(car.carID);
    final myFavoriteCars = _users.doc(userID).collection('myFavoriteCars');
    carDocRef.update({"carFavoriteCount": carFavoriteCount});
    myFavoriteCars.doc(car.carID).delete();
  }

  // Récuperation de toutes les voitures favoris de l'utilisateur en temps réel
  Stream<List<Car>> get myFavoriteCars {
    final myFavoriteCars = _users.doc(userID).collection('myFavoriteCars');
    final queryMyFCs = myFavoriteCars.orderBy('carTimestamp', descending: true);
    return queryMyFCs.snapshots().map((snapshot) {
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

  // suppression de la voiture
  Future<void> deleteCar(String carID) => _cars.doc(carID).delete();
}
