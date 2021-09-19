import 'package:fire_cars/views/home/addCarSection.dart';
import 'package:fire_cars/views/home/homeAppBar.dart';
import 'package:fire_cars/views/shared-ui/carList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          isAlwaysShown: kIsWeb ? true : false,
          showTrackOnHover: kIsWeb ? true : false,
          child: CustomScrollView(slivers: [
            HomeAppBar(user: _user),
            AddCarSection(user: _user),
            CarList(pageName: 'Accueil', userID: _user!.uid)
          ]),
        ),
      ),
    );
  }
}
