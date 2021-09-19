import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'maps_page.dart'; // For navigation

// For talking with the backend to submit database information.
import 'package:http/http.dart' as http;

//delete later
void main() => runApp(SelectScreen());

void UpdateActivity(String uid, int activityType, double pace, double distance, double time) async {
  var uri = "http://localhost:3000/api/update/activity?uid=" + uid + "&type=" + activityType.toString() + "&pace=" + pace.toString() +
  "&distance=" + distance.toString() + "&time=" + time.toString();
  try {
    var response = await http.get(Uri.parse(uri), headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    print('Response body: ${response.body}');
  } catch (e) {
    // just consume the error. Who cares.
    print(e);
    print(uri);
  }
}

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



class SelectScreenState extends State<SelectState> {

  late double inputD;
  late double inputT;
  late double inputP;

  var dController = new TextEditingController();
  var tController = new TextEditingController();
  var pController = new TextEditingController();

  late int activity;
  late bool isD;
  Color icon1Color = Colors.orangeAccent;
  Color icon2Color = Colors.white;
  Color icon3Color = Colors.white;

  @override
  void initState() {
    super.initState();
    inputD = 0.0;
    inputT = 0.0;
    inputP = 5.0;
    activity = 1;
    dController.text = "0";
    tController.text = "0";
    pController.text = "5";
  }

  Widget buildActivityOptions() {

    void UpdatePace(double newPace) {
      inputP = newPace;
      pController.text = inputP.toString();
      // Update the time
      inputT = inputD * inputP;
      tController.text = inputT.toString();
    }

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
                      UpdatePace(5.0);
                      print(activity);
                      icon1Color = Colors.orangeAccent;
                      icon2Color = Colors.white;
                      icon3Color = Colors.white;
                      UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
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
                      UpdatePace(13);
                      print(activity);
                      icon1Color = Colors.white;
                      icon2Color = Colors.orangeAccent;
                      icon3Color = Colors.white;
                      UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
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
                      UpdatePace(2);
                      print(activity);
                      icon1Color = Colors.white;
                      icon2Color = Colors.white;
                      icon3Color = Colors.orangeAccent;
                      UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
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
      child: Column(children: [
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            fillColor: Colors.white,
            filled: true,
            suffix: Text('min/km'),
            hintText: "Pace", // TODO: Needs to be stateful and dependent on option
          ),
          controller: pController,
          onChanged: (str) {
            try {
              inputP = double.parse(str);
              // TODO: The code below can be factored out.
              // Update the time
              inputT = inputD * inputP;
              tController.text = inputT.toString();
              UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
            } catch (e) {
              inputP = 0.0;
            }
          }
        ),
        SizedBox(
          height: 20,
        ),
        Row(children: [
          // distance input field
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: dController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  suffix: Text('km'),
                  hintText: "Distance",
              ),
              onChanged: (str) {
                try {
                  inputD = double.parse(str);
                  // recompute the time.
                  inputT = inputD * inputP;
                  tController.text = inputT.toString();
                  UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
                } catch (e) {
                  inputD = 0.0;
                }
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          // distance input field
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              controller: tController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  suffix: Text('min'),
                  hintText: "Time",
              ),
              onChanged: (str) {
                try {
                  inputT = double.parse(str);
                  // recompute the distance
                  if (inputP != 0) {
                    inputD = inputT / inputP;
                    dController.text = inputD.toString();
                    UpdateActivity("iwoYcZfWWWMiw8B2vpq7xhUgzMQ2", activity, inputP, inputD, inputT);
                  }
                } catch (e) {
                  inputT = 0.0;
                }
              },
            ),
          )
        ]),
      ])
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapsPage()),
            );
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()), );
          },
          child: Text('Community')),
    );
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapsPage()),
            );
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MyLoginPage()), );
          },
          child: Text('Solo')),
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
