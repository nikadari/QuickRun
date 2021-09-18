import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
              child: Image.asset(
            "assets/3.png",
            width: size.width * 0.3,
          )),
        ],
      ),
    );
  }
}
