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
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
            tag: user!.photoURL!,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: NetworkImage(user!.photoURL!),
                fit: BoxFit.cover,
              )),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.white, Colors.transparent],
                  begin: Alignment.bottomRight,
                )),
              ),
            )),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: '${user!.displayName}\n',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '${user!.email}',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.black,
                  ),
            )
          ]),
        ),
        titlePadding: EdgeInsets.only(left: 46.0, bottom: 8.0),
      ),
      actions: [
        IconButton(onPressed: () => signOut(context), icon: Icon(Icons.logout))
      ],
    );
  }

  signOut(BuildContext context) {
    Navigator.of(context).pop();
    AuthService().signOut();
  }
}
