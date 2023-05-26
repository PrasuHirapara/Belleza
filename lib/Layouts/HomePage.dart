import 'package:belleza/Layouts/SideBar.dart';
import 'package:belleza/Layouts/SideBar_Layouts/Offers.dart';
import 'package:belleza/Layouts/SideBar_Layouts/SavedDraft.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Constants/Admin.dart';
import 'Admin/admin_HomePageState.dart';
import 'SideBar_Layouts/Appointments.dart';
import 'SideBar_Layouts/ChatRoom.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => FirebaseAuth.instance.currentUser!.uid == "ieDmUFNqFMWmZmCLoNldGQqNDcI3" ? admin_HomePageState() : user_HomePageState();
}

class user_HomePageState extends State<HomePage> {
  int _productImages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: SideBar(title: FirebaseAuth.instance.currentUser!.uid),

      appBar: AppBar(
        title: Center(child: Text("belleza".toUpperCase(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(title: FirebaseAuth.instance.currentUser!.uid)));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5,right: 8),
                child: Icon(Icons.message,size: 30,),
              )
          )
        ],
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget> [

            SizedBox(height: 15,),

            Container(
              width: MediaQuery.of(context).size.width,
                height: 200,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('admin')
                        .doc('offers')
                        .collection(adminId)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot snapshot,
                        ) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        return Stack(
                          children: [
                            PageView.builder(
                              onPageChanged: (num) {
                                setState(() {
                                  _productImages = num;
                                });
                              },
                              itemCount: snapshot.data!.docs.length,
                              pageSnapping: true,
                              itemBuilder: (BuildContext context,
                                  int index) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              20),
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(
                                              20),
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => Offers(
                                                  title: snapshot.data!.docs[index]['image_url']))
                                               );
                                              },
                                            child: Hero(
                                              tag: 'home_TO_offers',
                                              child: Image.network(
                                                snapshot
                                                    .data!
                                                    .docs[index]
                                                ['image_url'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  for (var i = 0;i <snapshot.data!.docs.length;i++)
                                    AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      width: _productImages == i
                                          ? 20
                                          : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            15),
                                        color: _productImages == i
                                            ? Colors.red.shade900
                                            : Colors.blue.shade800
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
            )

          ],
        ),
      ),

        floatingActionButton: SpeedDial(
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
                label: 'Saved',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SavedDraft()));
                }
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
        )
    );
  }
}
