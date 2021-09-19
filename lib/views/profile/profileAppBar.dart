import 'package:fire_cars/services/authServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  final User? user;
  ProfileAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.40,
      pinned: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${user!.displayName}\n',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: '${user!.email}',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                  ),
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: user!.photoURL!,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user!.photoURL!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                  begin: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          tooltip: 'Retour vers la page accueil',
        ),
      ),
      actions: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: IconButton(
            onPressed: () => signOut(context),
            icon: Icon(Icons.logout),
            tooltip: 'Deconnectez-vous',
          ),
        ),
      ],
    );
  }

  signOut(BuildContext context) {
    Navigator.of(context).pop();
    AuthService().signOut();
  }
}
