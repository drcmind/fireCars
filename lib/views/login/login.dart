import 'dart:async';
import 'dart:io';

import 'package:fire_cars/services/authServices.dart';
import 'package:fire_cars/views/shared-ui/showSnackBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool inLoginProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    image: AssetImage('assets/fire_car.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                'Fire Cars',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Découvrez et partagez les meilleures voitures de luxes 2021',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              inLoginProcess
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      child: Text("Connectez-vous avec Google"),
                      onPressed: () => signIn(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future signIn(BuildContext context) async {
    if (kIsWeb) {
      setState(() {
        inLoginProcess = true;
        AuthService().signInWithGoogle();
      });
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() async {
            inLoginProcess = true;
            AuthService().signInWithGoogle();
          });
        }
      } on SocketException catch (_) {
        showNotification(context, 'Aucune connexion internet');
      }
    }
  }
}
