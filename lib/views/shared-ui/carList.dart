import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/carFeed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarList extends StatelessWidget {
  final String? pageName, userID;
  const CarList({this.pageName, this.userID});

  @override
  Widget build(BuildContext context) {
    final _cars = Provider.of<List<Car>>(context);
    return SliverList(
        delegate: SliverChildBuilderDelegate((_, index) {
      return StreamBuilder(
          stream: DatabaseService(userID: userID, carID: _cars[index].carID)
              .myFavoriteCar,
          builder: (context, snapshot) {
            final favoriteCar = snapshot.data as Car;
            if (pageName == 'Profile') {
              if (!snapshot.hasData) return Container();
              return CarFeed(
                  car: favoriteCar, userID: userID, isMyFavoriteCar: true);
            } else {
              if (!snapshot.hasData)
                return CarFeed(
                    car: _cars[index], userID: userID, isMyFavoriteCar: false);
              return CarFeed(
                  car: _cars[index], userID: userID, isMyFavoriteCar: true);
            }
          });
    }, childCount: _cars.length));
  }
}
