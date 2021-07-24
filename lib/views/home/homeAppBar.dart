import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final User? user;
  const HomeAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        title: Text('Fire cars'),
        elevation: 0.8,
        floating: true,
        forceElevated: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Hero(
                tag: user!.photoURL!,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user!.photoURL!),
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          )
        ]);
  }
}
