import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesatogotask/bottomNavBar/BottomNavigationBar.dart';
import 'package:vesatogotask/screens/DashBoardScreen.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Timer(Duration( milliseconds: 6000),() {
          navigateUser(); //It will redirect  after 3 seconds
        });
      }
    } on SocketException catch (_) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Data Connection'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Oops!!!You are not connected to Internet.'),
                  Text('Please try again!'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Try Again'),
                onPressed: () {
                  checkInternet();
                },
              ),
            ],
          );
        },
      );
    }
  }

  navigateUser()async{
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarUtil()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width:MediaQuery.of(context).size.width,
            child: TyperAnimatedTextKit(
              onTap: () {
                print("Tap Event");
              },
              text: [
                "Vesatogo Task",
              ],
              textStyle: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  letterSpacing: 0.6
              ),
              textAlign: TextAlign.center,
              alignment: AlignmentDirectional.topStart,
              speed: Duration(milliseconds: 140),
              isRepeatingAnimation: false,// or Alignment.topLeft
            ),
          ),
        ],
      ),
    );
  }
}
