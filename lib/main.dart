import 'package:beamer/beamer.dart';
import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/authServices.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'beamDelegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      StreamProvider<User?>.value(
        initialData: null,
        value: AuthService().user,
      ),
      StreamProvider<List<Car>>.value(
        initialData: [],
        value: DatabaseService().cars,
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final _routerDelegate = routerDelegate(context);
    return BeamerProvider(
      routerDelegate: _routerDelegate,
      child: MaterialApp.router(
        title: 'Fire cars',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.amber,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        routerDelegate: _routerDelegate,
        routeInformationParser: BeamerParser(),
        builder: (context, child) {
          return StreamBuilder(
            initialData: 'loading',
            stream: AuthService().user,
            builder: (context, snapshot) {
              if (snapshot.data.toString() != 'loading') return child!;
              return SplashScreen();
            },
          );
        },
      ),
    );
  }
}
