import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String? carID, carName, carUrlImg, carUserID, carUserName;
  Timestamp? carTimestamp;
  bool? isMyFavoritedCar;
  int? carFavoriteCount;
  Car(
      {this.carID,
      this.carName,
      this.carUrlImg,
      this.carUserID,
      this.carUserName,
      this.carTimestamp,
      this.isMyFavoritedCar,
      this.carFavoriteCount});
}
