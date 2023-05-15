import 'dart:async';

import 'package:belleza/Layouts/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(child: Text("Profile")),
          ),
        ),

        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Column(
                children: [
                 SizedBox(height: 20,),

                 Container(
                   width: 130,
                   height: 130,
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(100),
                     child: Image(
                       image: AssetImage('assets/icons/user_logo.png'),
                       // loadingBuilder: (context, child, loadingProgress){
                       //   return CircularProgressIndicator();
                       // },
                     ),
                   ),
                 ),

                 SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListTile(
                       leading: Icon(Icons.perm_identity),
                       title: Text("First Name : "+HomePage.first_name.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                   ),
                 ),

                 SizedBox(height: 15,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListTile(
                       leading: Icon(Icons.perm_identity),
                       title: Text("Last Name : "+HomePage.last_name.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                   ),
                 ),

                 SizedBox(height: 15,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListTile(
                       leading: Icon(Icons.email),
                       title: Text("Email : ".toUpperCase() +HomePage.email,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                   ),
                 ),

                 SizedBox(height: 15,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListTile(
                       leading: Icon(Icons.phone),
                       title: Text("Mobile Number : "+HomePage.phone_number.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                   ),
                 ),

                 SizedBox(height: 15,),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListTile(
                       leading: Icon(Icons.date_range),
                       title: Text("Registration Date : "+HomePage.registration_date.toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                     ),
                   ),
                  ),
                 ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
