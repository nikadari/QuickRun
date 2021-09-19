import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart'; // How to import a library.
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:html';
import 'dart:ui' as ui;

void main() {
  ui.platformViewRegistry.registerViewFactory(
    'hello-world-html',
    (int viewId) => IFrameElement()
    ..width = '640'
    ..height = '360'
    ..src = 'https://localhost:3000'
    ..style.border = 'none');
  runApp(MyApp());
}

// For doing state in the app, it works like so.

// We have a StatefulWidget
// We have a State class
//

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This gets run everytime the app requires rendering.
    return MaterialApp(
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

  // Determining the screen width and height.
  // var height = MediaQuery.of(context).size.height;
  // var width = MediaQuery.of(context).size.width;

  // Directions API to get back a path, and we can include intermediate
  // waypoints. So this is what we are going to do on the backend.

  // Common to use late in combination with Final.
  // Initializes the variable when it is first read rather than created.
  late GoogleMapController mapController;
  // Just some random location it seems.
  final LatLng _center = const LatLng(44.228690, -76.487910);
  //var LatLng secondary_location = const LatLng(44.224582, -76.492615);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {

    // Here is the MEAT JUICE of the code, btw.
    // We need to know the pace that they plan to run at.
    // Assumming right now JUST using for running.
    // Need to know either the distance or the time.
    // We also need the starting location of the person,
    // in latitude and longitude.

    /*
    Future<http.Response> fetchPath(double pace, double lat, double lon, {double distance, double time}) {
      var uri = "https://localhost:3000/api/path?pace=" + toString(pace) + "&lat=" + toString(lat) +
      "&lon=" + toString(lon);
      if (distance != null) uri = uri + "&distance=" + toString(distance);
      if (time != null) uri = uri + "&time=" + toString(time);
      return http.get(Uri.parse(uri));
    }*/

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: Container(
          padding: EdgeInsets.all(5.0),
          child: Image.asset(
            "assets/2.png",
            width: 64,
            height: 64,
          ),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Image.asset(
            "assets/2.png",
            width: 64,
            height: 64,
          ),
        ),
      ),

      /*
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0
        )
      ),
      */
      body: SizedBox(
        width: 640,
        height: 360,
        child: HtmlElementView(viewType: 'hello-world-html'),
      )
    );
  }

  /*
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // this is an anonymous function.
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        // Final variable can only be set once. Whereas the const variable
        // is set at compile time.
        final index = i ~/ 2; // truncating division operator.
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont
      )
    );
  }
  */

}
