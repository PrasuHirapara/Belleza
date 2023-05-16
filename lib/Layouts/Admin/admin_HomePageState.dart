import 'dart:io';

import 'package:belleza/Constants/Admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../HomePage.dart';
import '../SideBar.dart';
import '../SideBar_Layouts/Appointments.dart';
import '../SideBar_Layouts/Consultant.dart';
import '../SideBar_Layouts/Offers.dart';

class admin_HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    int _productImages = 1;

    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: SideBar(),

      appBar: AppBar(
        title: Center(child: Text("belleza".toUpperCase(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Consultant()));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5,right: 8),
                child: Icon(Icons.message,size: 30,),
              )
          )
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 20,),

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
              label: 'Upload Document',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                 ImagePicker imagePicker = ImagePicker();
                 XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                 String uniqueFileName = Timestamp.now().toString();

                 showDialog(
                     context: context,
                     builder: (ctx) => AlertDialog(
                       title: Text('Upload Image',style: TextStyle(fontSize: 30),),
                       content: Text('Are you sure want to Upload Image ?',style: TextStyle(fontSize: 15),),
                       actions: [
                         TextButton(
                           onPressed: () {
                             Navigator.pop(context);
                           },
                           child: Text('NO'),
                         ),
                         TextButton(
                           onPressed: () async {

                             Reference referenceRoot = FirebaseStorage.instance.ref();
                             Reference referenceDirImage = referenceRoot.child('admin/offers');

                             Reference referenceImageToUpload = referenceDirImage.child("$uniqueFileName");

                             try{
                               await referenceImageToUpload.putFile(File(file!.path));

                               String url = await referenceImageToUpload.getDownloadURL();

                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded"),duration: Duration(seconds: 1),));

                               FirebaseFirestore.instance
                                   .collection('admin')
                                   .doc('offers')
                                   .collection(FirebaseAuth.instance.currentUser!.uid)
                                   .add({
                                 'image_url': url,
                                 'timestamp': Timestamp.now(),
                               });

                               Navigator.of(context, rootNavigator: true).pop();

                             }catch(error){
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 2),));
                               Navigator.of(context, rootNavigator: true).pop();
                             }
                           },
                           child: Text('YES'),
                         ),
                       ],
                     )
                 );
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