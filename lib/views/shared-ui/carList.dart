import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/carFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CarList extends StatelessWidget {
  final String? pageName, userID;
  const CarList({this.pageName, this.userID});

  @override
  Widget build(BuildContext context) {
    final _cars = Provider.of<List<Car>>(context);
    final vw = MediaQuery.of(context).size.width;
    final isMobil = vw <= 599;
    final isTablet = vw <= 1024;
    final isDeskTop = vw > 1024;
    return SliverPadding(
      padding: isDeskTop
          ? EdgeInsets.symmetric(horizontal: vw * 0.1)
          : EdgeInsets.zero,
      sliver: SliverStaggeredGrid.countBuilder(
        crossAxisCount: isMobil
            ? 1
            : isTablet
                ? 2
                : 3,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final db = DatabaseService(userID: userID, carID: _cars[index].carID);
          return StreamBuilder(
            stream: db.myFavoriteCar,
            builder: (context, snapshot) {
              if (pageName == 'Profile') {
                if (!snapshot.hasData) return Container();
                _cars[index].isMyFavoritedCar = true;
                return CarFeed(car: _cars[index], userID: userID);
              }
              if (!snapshot.hasData) {
                _cars[index].isMyFavoritedCar = false;
                return CarFeed(car: _cars[index], userID: userID);
              } else {
                _cars[index].isMyFavoritedCar = true;
                return CarFeed(car: _cars[index], userID: userID);
              }
            },
          );
        },
      ),
    );
  }
}
