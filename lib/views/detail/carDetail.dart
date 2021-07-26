import 'package:fire_cars/models/carModel.dart';
import 'package:fire_cars/services/dbServices.dart';
import 'package:fire_cars/views/shared-ui/showSnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CarDetail extends StatelessWidget {
  const CarDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as Car;
    final _userID = Provider.of<User?>(context)!.uid;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(car.carName!, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          car.carUserID == _userID
              ? IconButton(
                  onPressed: () => onDeleteCar(context, car),
                  icon: Icon(Icons.delete),
                )
              : Container()
        ],
      ),
      body: InteractiveViewer(
        child: Hero(
          tag: car.carName!,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: NetworkImage(car.carUrlImg!),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  onDeleteCar(BuildContext context, Car car) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Voulez-vous supprimer votre ${car.carName} ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ANNULER'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    DatabaseService().deleteCar(car.carID!);
                    showNotification(context, 'Supprimer avec succès');
                  },
                  child: Text('SUPPRIMER'))
            ],
          );
        });
  }
}
