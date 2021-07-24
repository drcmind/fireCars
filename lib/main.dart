import 'package:fire_cars/services/authServices.dart';
import 'package:fire_cars/views/detail/carDetail.dart';
import 'package:fire_cars/views/profile/profile.dart';
import 'package:fire_cars/views/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<User?>.value(
    initialData: null,
    value: AuthService().user,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/profile': (context) => Profile(),
        '/detail': (context) => CarDetail()
      },
    );
  }
}
