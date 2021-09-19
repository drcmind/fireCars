import 'dart:io';

import 'package:fire_cars/views/home/showCarDialog.dart';
import 'package:fire_cars/views/shared-ui/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCarSection extends StatelessWidget {
  final User? user;
  const AddCarSection({this.user});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Salut'),
                    Text(
                      user!.displayName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search),
                        tooltip: 'Rechercher dans Fire Cars',
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      child: IconButton(
                        onPressed: () => showCarDialog(context, user!),
                        icon: Icon(Icons.add),
                        tooltip: 'Ajouter une voiture',
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showCarDialog(BuildContext context, User user) async {
    if (kIsWeb) {
      CarDialog(user: user).showCarDialog(context, ImageSource.gallery);
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          CarDialog(user: user).showCarDialog(context, ImageSource.gallery);
        }
      } on SocketException catch (_) {
        showNotification(context, 'Aucune connexion internet');
      }
    }
  }
}
