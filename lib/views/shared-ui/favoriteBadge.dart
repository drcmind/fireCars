import 'dart:io';

import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/showSnackBar.dart';
import 'package:flutter/material.dart';

class FavoriteBadge extends StatefulWidget {
  final Car? car;
  final String? userID;
  FavoriteBadge({this.car, this.userID});

  @override
  _FavoriteBadgeState createState() => _FavoriteBadgeState();
}

class _FavoriteBadgeState extends State<FavoriteBadge> {
  bool isMyFavoriteCar = false;
  @override
  Widget build(BuildContext context) {
    DatabaseService()
        .isMyFavoriteCars(widget.car!.carID!, widget.userID!)
        .then((value) => setState(() => isMyFavoriteCar = value));
    return Positioned(
        top: 4.0,
        right: 12.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white.withOpacity(0.7),
          ),
          child: isMyFavoriteCar
              ? GestureDetector(
                  onTap: () => onRemoveFavoriteCar(widget.car!, widget.userID!),
                  child: Row(
                    children: [
                      Text('${widget.car!.carFavoriteCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => onAddFavoriteCar(widget.car!, widget.userID!),
                  child: Row(
                    children: [
                      widget.car!.carFavoriteCount! > 0
                          ? Text('${widget.car?.carFavoriteCount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ))
                          : Container(),
                      Icon(
                        Icons.favorite,
                      )
                    ],
                  ),
                ),
        ));
  }

  void onAddFavoriteCar(Car car, String userID) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isMyFavoriteCar = true;
          int carFavoriteCount = car.carFavoriteCount!;
          int increaseCount = carFavoriteCount += 1;
          car.carFavoriteCount = increaseCount;
          DatabaseService().addFavoriteCar(car, userID, increaseCount);
        });
      }
    } on SocketException catch (_) {
      showNotification(context, 'Aucune connexion internet');
    }
  }

  void onRemoveFavoriteCar(Car car, String userID) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isMyFavoriteCar = false;
          int carFavoriteCount = car.carFavoriteCount!;
          int decreaseCount = carFavoriteCount -= 1;
          car.carFavoriteCount = decreaseCount;
          DatabaseService().removeFavoriteCar(car, userID, decreaseCount);
        });
      }
    } on SocketException catch (_) {
      showNotification(context, 'Aucune connexion internet');
    }
  }
}
