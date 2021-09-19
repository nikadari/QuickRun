import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'select.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // This gets run everytime the app requires rendering.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickRun',
      home: AppGame(),
    );
  }
}

class AppGame extends StatefulWidget {
  // Note that the arrow syntax is quite like the same that is used in
  // Javascript. Cool.
  @override
  _AppGameState createState() => _AppGameState();
}

// Prefixing with the underscore enforces privacy in the Dart language.
// the templating syntax is in fact to make a generic state specific for the
// RandomWords class.
class _AppGameState extends State<AppGame> {

  Future<Position> futurePos = _determinePosition();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.white
          ),
          iconSize: 32,
          padding: EdgeInsets.all(10),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectScreen()),
            );
          }
        )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[600],
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: IconButton(
            icon: Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white
            ),
            iconSize: 64,
            onPressed: () {
              print("Go.");
          }),
        )
      ),
      body: Visibility(
        child: FutureBuilder<Position>(
          future: futurePos,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            var pos = snapshot.data;
            if (pos != null) {
                //print(pos);
                var lat = pos.latitude;
                var lon = pos.longitude;
                ui.platformViewRegistry.registerViewFactory(
                  'hello-world-html',
                  (int viewId) => IFrameElement()
                  ..src = 'http://localhost:3000/api/path?uid=iwoYcZfWWWMiw8B2vpq7xhUgzMQ2&lat=' + lat.toString() + "&lon=" + lon.toString()
                  //..src = 'http://localhost:3000/api/debug?uid=iwoYcZfWWWMiw8B2vpq7xhUgzMQ2&lat=' + lat.toString() + "&lon=" + lon.toString()
                  ..style.border = 'none'
                );
                return HtmlElementView(viewType: 'hello-world-html');
            } else {
              return SpinKitRotatingCircle(
                color: Colors.grey,
                size: 50.0,
              );
            }
          }
        ),
      ),
    );
  }
}
