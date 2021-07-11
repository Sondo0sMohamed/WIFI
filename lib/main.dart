import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  // This widget is the root of your application.
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  OpenPainter painter = new OpenPainter();

  DatabaseReference itemRef;
  double location = 0;
  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   setState(() {});
    // });

    super.initState();
    // item = Item("", "");
    debugPrint("here");

    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    itemRef = database.reference().child('/class');
    // itemRef.onChildAdded.listen(_onEntryAdded);
    itemRef.onChildChanged.listen(_onEntryChanged);
  }

  //_onEntryAdded(Event event) {
  //setState(() {
  // items.add(Item.fromSnapshot(event.snapshot));
  //});
  // }

  _onEntryChanged(Event event) {
    // var old = items.singleWhere((entry) {
    //   return entry.key == event.snapshot.key;
    // });
    debugPrint(event.snapshot.key);
    setState(() {
      this.location = 1.0 * event.snapshot.value;
      this.painter.move(this.location);
      // items[items.indexOf(old)] = Item.fromSnapshot(event.snapshot);
      // painter.location = event.snapshot.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('location: ' + this.location.toString()),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image(image: AssetImage('assets/door.png')),
          CustomPaint(
            painter: this.painter,
          ),
        ],
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  double horizontal = 0, vertical = 0;
  double location = 0;

  void printLoc() {
    if (location == 0) {
      vertical = -250;
      horizontal = -175;
    } else if (location == 1) {
      vertical = -250;
      horizontal = -75;
    } else if (location == 2) {
      vertical = -250;
      horizontal = 10;
    } else if (location == 3) {
      vertical = -140;
      horizontal = 10;
    } else if (location == 4) {
      vertical = -40;
      horizontal = 10;
    } else if (location == 5) {
      vertical = -40;
      horizontal = -100;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.red[700]
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 15;
    //list of points
    var points = [
      Offset(this.horizontal, this.vertical),
    ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
  void move(double location) {
    this.location = location;
    this.printLoc();
  }
}
