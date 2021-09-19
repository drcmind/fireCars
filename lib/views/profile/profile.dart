import 'package:fire_cars/views/profile/profileAppBar.dart';
import 'package:fire_cars/views/shared-ui/carList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User?>(context);
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          isAlwaysShown: kIsWeb ? true : false,
          showTrackOnHover: kIsWeb ? true : false,
          child: CustomScrollView(
            slivers: [
              ProfileAppBar(user: _user),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 16.0,
                      bottom: 12.0,
                    ),
                    child: Text(
                      'Vos voitures favoris',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider()
                ]),
              ),
              CarList(pageName: 'Profile', userID: _user!.uid)
            ],
          ),
        ),
      ),
    );
  }
}
