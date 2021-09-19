import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:flutter/material.dart';

class FavoriteBadge extends StatefulWidget {
  final Car? car;
  final String? userID;
  FavoriteBadge({this.car, this.userID});

  @override
  _FavoriteBadgeState createState() => _FavoriteBadgeState();
}

class _FavoriteBadgeState extends State<FavoriteBadge> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4.0,
      right: 12.0,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white.withOpacity(0.7),
          ),
          child: widget.car!.isMyFavoritedCar!
              ? GestureDetector(
                  onTap: () => DatabaseService()
                      .removeFavoriteCar(widget.car!, widget.userID!),
                  child: Tooltip(
                    message: 'Ne plus aimer',
                    child: Row(
                      children: [
                        Text(
                          '${widget.car!.carFavoriteCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => DatabaseService()
                      .addFavoriteCar(widget.car!, widget.userID!),
                  child: Tooltip(
                    message: 'Aimer',
                    child: Row(
                      children: [
                        widget.car!.carFavoriteCount! > 0
                            ? Text(
                                '${widget.car?.carFavoriteCount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Container(),
                        Icon(
                          Icons.favorite,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
