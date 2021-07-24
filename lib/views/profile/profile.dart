import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/profile/profileAppBar.dart';
import 'package:fire_cars/views/shared-ui/carsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return StreamProvider<List<Car>>.value(
      initialData: [],
      value: DatabaseService(userID: _user!.uid).myFavoriteCars,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            final _myFavoriteCars = Provider.of<List<Car>>(context);
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  ProfileAppBar(user: _user),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, left: 16.0, bottom: 12.0),
                        child: Text(
                          'Vos voitures favoris',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Divider()
                  ])),
                  CarList(cars: _myFavoriteCars, userID: _user.uid)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
