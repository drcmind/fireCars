import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/views/shared-ui/favoriteBadge.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CarList extends StatelessWidget {
  final List<Car>? cars;
  final String? userID;
  const CarList({this.cars, this.userID});
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((contex, index) {
      return Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/detail',
                    arguments: cars![index]),
                child: Hero(
                  tag: cars![index].carName!,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.grey,
                        image: DecorationImage(
                            image: NetworkImage(cars![index].carUrlImg!),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
              FavoriteBadge(car: cars![index], userID: userID),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cars![index].carName!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('De ${cars![index].carUserName!}'),
                  ],
                ),
                Text(formattingDate(cars![index].carTimestamp))
              ],
            ),
          )
        ],
      );
    }, childCount: cars!.length));
  }

  String formattingDate(Timestamp? timestamp) {
    initializeDateFormatting('fr', null);
    DateTime? dateTime = timestamp?.toDate();
    DateFormat dateFormat = DateFormat.MMMd('fr');
    return dateFormat.format(dateTime ?? DateTime.now());
  }
}
