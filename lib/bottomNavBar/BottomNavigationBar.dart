import 'package:flutter/material.dart';
import 'package:vesatogotask/screens/AccountScreen.dart';
import 'package:vesatogotask/screens/DashBoardScreen.dart';
import 'package:vesatogotask/screens/TrackingScreen.dart';

class BottomNavigationBarUtil extends StatefulWidget {
  @override
  _BottomNavigationBarUtilState createState() => _BottomNavigationBarUtilState();
}

class _BottomNavigationBarUtilState extends State<BottomNavigationBarUtil> {
  int selectedItemIndex = 0 ;
  var screens = [DashBoard(),Tracking(),Account()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: screens[selectedItemIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard),title:Text('Dashboard')),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),title:Text('Tracking')),
          BottomNavigationBarItem(icon: Icon(Icons.location_on),title:Text('Account')),
        ],
        currentIndex: selectedItemIndex,
        onTap: (index){
          setState(() {
            selectedItemIndex = index;
          });
        },
      ),
    );
  }
}
