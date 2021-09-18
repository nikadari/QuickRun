import 'package:flutter/material.dart';
import 'welcome_body.dart';

void main() => runApp(WelcomeScreen());

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
  // build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'QuickRun',
  //     theme: ThemeData(
  //       scaffoldBackgroundColor: const Color(0xFF545454),
  //     ),
  //     home: MyWelcomePage(),
  //   );
  // }
}

class MyWelcomePage extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<MyWelcomePage> {
  //Variables

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppBar appBar = AppBar(
    //   title: Text("QuickRun"),
    // );

    Container logo = Container(
      padding: EdgeInsets.all(20.0),
      child: Image.asset(
        "assets/3.png",
        width: 1024,
        height: 600,
      ),
    );

    return Scaffold(
      //appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              logo,
            ],
          ),
        ),
      ),
    );
  }
}
