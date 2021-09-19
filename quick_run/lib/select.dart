import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//delete later
void main() => runApp(SelectScreen());

class SelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectState(),
    );
  }
}

class SelectState extends StatefulWidget {
  @override
  SelectScreenState createState() => SelectScreenState();
}

Widget buildSoloBtn() {
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
          //Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()), );
        },
        child: Text('Solo')),
  );
}

class SelectScreenState extends State<SelectState> {
  late double inputD;
  late double inputT;
  late int activity;
  late bool isD;
  Color icon1Color = Colors.white;
  Color icon2Color = Colors.white;
  Color icon3Color = Colors.white;

  @override
  void initState() {
    super.initState();
    inputD = 0.0;
    inputT = 0.0;
    activity = 1;
  }

  Widget buildActivityOptions() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Wrap(
        children: <Widget>[
          //RUNNING
          Column(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.directions_run,
                    color: icon1Color,
                  ),
                  iconSize: 50.0,
                  onPressed: () {
                    setState(() {
                      activity = 1;
                      print(activity);
                      icon1Color = Colors.orangeAccent;
                      icon2Color = Colors.white;
                      icon3Color = Colors.white;
                    });
                  }),
              Text("Running",
                  style: TextStyle(
                    color: icon1Color,
                    fontSize: 16,
                  )),
            ],
          ),
          SizedBox(width: 50),

          //WALKING
          Column(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.directions_walk,
                    color: icon2Color,
                  ),
                  iconSize: 50.0,
                  onPressed: () {
                    setState(() {
                      activity = 2;
                      print(activity);
                      icon1Color = Colors.white;
                      icon2Color = Colors.orangeAccent;
                      icon3Color = Colors.white;
                    });
                  }),
              Text("Walking",
                  style: TextStyle(
                    color: icon2Color,
                    fontSize: 16,
                  )),
            ],
          ),
          SizedBox(width: 50),

          //CYCLING
          Column(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.directions_bike,
                    color: icon3Color,
                  ),
                  iconSize: 50.0,
                  onPressed: () {
                    setState(() {
                      activity = 3;
                      print(activity);
                      icon1Color = Colors.white;
                      icon2Color = Colors.white;
                      icon3Color = Colors.orangeAccent;
                    });
                  }),
              Text("Cycling",
                  style: TextStyle(
                    color: icon3Color,
                    fontSize: 16,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDTFields() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: "Distance (km)"),
            onChanged: (str) {
              try {
                inputD = double.parse(str);
              } catch (e) {
                inputD = 0.0;
              }
            },
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
                hintText: "Time (min)"),
            onChanged: (str) {
              try {
                inputT = double.parse(str);
              } catch (e) {
                inputT = 0.0;
              }
            },
          ),
        )
      ]),
    );
  }

  Widget buildCommunityBtn() {
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
            textStyle:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()), );
          },
          child: Text('Community')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        leading: Icon(
          Icons.account_circle_outlined,
          color: Colors.white,
        ),
        actions: [],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF616161),
                      Color(0xFF424242),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25,
                    //vertical: 120,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/4.png',
                          width: 300,
                        ),
                      ),
                      Text(
                        "How are we moving today?",
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[200],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      buildActivityOptions(),
                      buildDTFields(),
                      buildSoloBtn(),
                      buildCommunityBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
