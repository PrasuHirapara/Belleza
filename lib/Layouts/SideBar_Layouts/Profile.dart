import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.title}) : super(key: key);

  final String title;
  static final String user_uid = FirebaseAuth.instance.currentUser!.uid;
  static String image_url = "";
  static String first_name = "";
  static String last_name = "";
  static String email = "";
  static String phone_number = "";
  static String registration_date = "";
  static bool isImage = !(image_url == "");

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isVisible = false;

  @override
  initState() {
    super.initState();

    fetchUserInformation(widget.title);

    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                   borderRadius: BorderRadius.circular(200),
                   child: Profile.isImage ?
                   Image(image: NetworkImage(Profile.image_url),) :
                   GestureDetector(
                       onTap: () {
                         showBottomAlertDialog(context);
                       },
                       child: Hero(
                        tag: 'chatroomTOprofile',
                          child: Image( image: AssetImage('assets/icons/user_logo.png'),)
                       )
                   ),
                 ),
               ),

               SizedBox(height: 20,),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.blueGrey[200],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: ListTile(
                     leading: Icon(Icons.perm_identity),
                     title: Text("First Name : "+Profile.first_name.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                   ),
                 ),
               ),

               SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.blueGrey[200],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: ListTile(
                     leading: Icon(Icons.perm_identity),
                     title: Text("Last Name : "+Profile.last_name.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                   ),
                 ),
               ),

               SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.blueGrey[200],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: ListTile(
                     leading: Icon(Icons.email),
                     title: Text("Email : ".toUpperCase() +Profile.email,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                   ),
                 ),
               ),

               SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.blueGrey[200],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: ListTile(
                     leading: Icon(Icons.phone),
                     title: Text("Mobile Number : "+Profile.phone_number.toString().toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                   ),
                 ),
               ),

               SizedBox(height: 15,),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     color: Colors.blueGrey[200],
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: ListTile(
                     leading: Icon(Icons.date_range),
                     title: Text("Registration Date : "+Profile.registration_date.toUpperCase(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                   ),
                 ),
                ),
               ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot documentSnapshot =
    await firestore.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  void fetchUserInformation(String userId) async {
    Map<dynamic, dynamic>? userData = await getUserData(userId);

    if (userData != null) {
      setState(() {
        Profile.first_name = userData['first_name'];
        Profile.last_name = userData['last_name'];
        Profile.email = userData['email'];
        Profile.phone_number = userData['phone_number'];
        Profile.registration_date = userData['registration_date'];
        Profile.image_url = userData['image_url'];
      });
    } else {
      print('User data not found.');
    }
  }

  void showBottomAlertDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (_) => imageDialog('My Image', 'assets/icons/user_logo.png', "", context, false)
                            );
                          },
                          child: Text('View Image',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15),),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text('Update Image',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  Widget imageDialog(text, default_path, network_path, context, bool isImage) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            child: Card(
              child: Hero(
                tag: 'chatroomImage',
                child: isImage? Image.network(network_path) : Image(image: AssetImage(default_path),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
