import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(WelcomeScreen());

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWelcomePage(),
    );
  }
}

class MyWelcomePage extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

Widget buildSignUpBtn() {
  return GestureDetector(
    onTap: () => print("Sign up pressed"),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an Account? ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildLogInBtn(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 25),
    width: 300,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(10.0),
          primary: Color(0xFFfb8c00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyLoginScreen()),
          );
        },
        child: Text('Login')),
  );
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
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF616161),
                    Color(0xFF424242),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                children: <Widget>[
                  logo,
                  buildLogInBtn(context),
                  buildSignUpBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   //appBar: appBar,
    //   body: SingleChildScrollView(
    //     child: Container(
    //       constraints: BoxConstraints(
    //         maxHeight: MediaQuery.of(context).size.height,
    //         maxWidth: MediaQuery.of(context).size.width,
    //       ),
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [
    //             Color(0xFF616161),
    //             Color(0xFF424242),
    //           ],
    //           begin: Alignment.topLeft,
    //           end: Alignment.centerRight,
    //         ),
    //       ),
    //       child: Column(
    //         children: <Widget>[
    //           logo,
    //           login,
    //           buildSignUpBtn(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
