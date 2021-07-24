import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/home/addCarSection.dart';
import 'package:fire_cars/views/home/homeAppBar.dart';
import 'package:fire_cars/views/shared-ui/carsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return StreamProvider<List<Car>>.value(
      initialData: [],
      value: DatabaseService().cars,
      child: Builder(
        builder: (BuildContext context) {
          final _cars = Provider.of<List<Car>>(context);
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(slivers: [
                HomeAppBar(user: _user),
                AddCarSection(user: _user),
                CarList(cars: _cars, userID: _user!.uid)
              ]),
            ),
          );
        },
      ),
    );
  }
}
