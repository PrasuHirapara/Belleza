import 'package:belleza/Layouts/SideBar.dart';
import 'package:belleza/Layouts/SideBar_Layouts/Appointments.dart';
import 'package:belleza/Layouts/SideBar_Layouts/Consultant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'SideBar_Layouts/ChatRoom.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static String first_name = "";
  static String last_name = "";
  static String email = "";
  static String phone_number = "";
  static String uid = FirebaseAuth.instance.currentUser!.uid;
  static String registration_date = "";
  static bool isAdmin = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: SideBar(),

      appBar: AppBar(
        title: Center(child: Text("belleza".toUpperCase(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
        actions: [
          GestureDetector(
            onTap: (){
              HomePage.isAdmin ? Navigator.push(context, MaterialPageRoute(builder: (context) => Consultant())) :
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(title: HomePage.uid)));
            },
              child: Padding(
                padding: const EdgeInsets.only(top: 5,right: 8),
                child: Icon(Icons.message,size: 30,),
              )
          )
        ],
      ),

      body: Container(),

      floatingActionButton: HomePage.isAdmin ? SpeedDial(
        childMargin: EdgeInsets.only(bottom: 10), //margin bottom
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.black,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        buttonSize: Size(50, 50), //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,

        elevation: 8.0,
        shape: CircleBorder(),

        children: [
          SpeedDialChild(
            child: Icon(Icons.upload),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            label: 'Upload Document',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.bookmark_add),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.grey[300],
            label: 'View Appointments',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments())),
          ),
        ],
      ) :
      SpeedDial(
        childMargin: EdgeInsets.only(bottom: 10), //margin bottom
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.black,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        buttonSize: Size(50, 50), //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,

        elevation: 8.0,
        shape: CircleBorder(),

        children: [
          SpeedDialChild(
            child: Icon(Icons.upload),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            label: 'Upload Document',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: Icon(Icons.bookmark_add),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.grey[300],
            label: 'Book Appointment',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments())),
          ),
        ],
      ),
    );
  }
}