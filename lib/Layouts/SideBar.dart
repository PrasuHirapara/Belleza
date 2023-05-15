import 'package:belleza/Layouts/HomePage.dart';
import 'package:belleza/Layouts/SideBar_Layouts/ChatRoom.dart';
import 'package:belleza/Layouts/SideBar_Layouts/Consultant.dart';
import 'package:belleza/Layouts/SideBar_Layouts/SocialMedia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'SideBar_Layouts/About.dart';
import 'SideBar_Layouts/Appointments.dart';
import 'SideBar_Layouts/Offers.dart';
import 'SideBar_Layouts/Payment.dart';
import 'SideBar_Layouts/Policies.dart';
import 'SideBar_Layouts/Reminder.dart';
import 'SideBar_Layouts/Setting.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  @override
  Widget build(BuildContext context){
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder(
            stream:
              FirebaseFirestore.instance
                  .collection("users")
                  .where("user_uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot){
              if(snapShot.hasData){
                return ListView.builder(
                    itemCount: snapShot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context,i){
                  var data = snapShot.data!.docs[i];

                  HomePage.first_name = data['first_name'];
                  HomePage.last_name = data['last_name'];
                  HomePage.email = data['email'];
                  HomePage.registration_date = data['registration_date'];
                  HomePage.phone_number = data['phone_number'];
                  HomePage.uid = data['user_uid'];
                  if(data['admin'] == "true"){
                    HomePage.isAdmin = true;
                    print(HomePage.isAdmin);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(25)
                        ),
                        accountName: Text(HomePage.first_name.toString().toUpperCase() + " " + HomePage.last_name.toString().toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black),
                        ),
                        accountEmail: Text(HomePage.email,
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),
                        ),
                        currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                            child: Image(image: AssetImage('assets/icons/user_logo.png'),
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                      ),
                    )
                    )),
                  );
                });
              }else{
                return CircularProgressIndicator();
              }
            },
          ),

          Divider(height: 5,),

          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text("Offers",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Offers()));
            },
          ),


          ListTile(
            leading: Icon(Icons.message),
            title: Text("Appointments",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Appointments()));
            },
          ),

          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text("Consultant",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              HomePage.isAdmin ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => Consultant())) :
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(title: HomePage.uid,)));
            },
          ),

          ListTile(
            leading: Icon(Icons.rate_review_rounded),
            title: Text("Reminder",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Reminder()));
            },
          ),

          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Payment",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.contact_page),
            title: Text("Social Media",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SocialMedia()));
            },
          ),

          ListTile(
            leading: Icon(Icons.policy),
            title: Text("Policies",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Policies()));
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
            },
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("About",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
            },
          ),
        ],
      ),
    );
  }
}
