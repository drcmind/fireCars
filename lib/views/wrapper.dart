import 'package:fire_cars/views/home/home.dart';
import 'package:fire_cars/views/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // retourne la page Accueil ou Login pour l'authentification
    final _user = Provider.of<User?>(context);
    return _user == null ? Login() : Home();
  }
}
