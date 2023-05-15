import 'package:belleza/Layouts/HomePage.dart';
import 'package:belleza/Layouts/SideBar_Layouts/ChatRoom.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Consultant extends StatefulWidget {

  @override
  _Consultant createState() => _Consultant();
}

class _Consultant extends State<Consultant> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text('Consultant')),
        ),
      ),
      body: HomePage.isAdmin ?
      ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 20,),

           StreamBuilder(
           stream:
           FirebaseFirestore.instance
               .collection("users")
               .snapshots(),
           builder: (context, AsyncSnapshot<QuerySnapshot> snapShot){
             if(snapShot.hasData){
               return ListView.builder(
                   itemCount: snapShot.data!.docs.length,
                   shrinkWrap: true,
                   itemBuilder: (context,i){

                     return Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Column(
                         children: [
                           Container(
                             decoration: BoxDecoration(
                               color: Colors.grey[300],
                               borderRadius: BorderRadius.circular(40)
                             ),
                             child: GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(title: snapShot.data!.docs[i]['user_uid'])));
                               },
                               child: ListTile(
                                   leading: CircleAvatar(
                                       child: ClipOval(
                                         child: Image(image: AssetImage('assets/icons/user_logo.png'),
                                           fit: BoxFit.cover,
                                           width: 90,
                                           height: 90,
                                         ),
                                       )
                                   ),
                                 title: Text(snapShot.data!.docs[i]['first_name'].toString().toUpperCase()+" "+snapShot.data!.docs[i]['last_name'].toString().toUpperCase(),
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(height: 20,)
                         ],
                       ),
                     );
                   });
                 }else{
                   return CircularProgressIndicator();
               }
              },
             ),
           ]
          ) :
          Container(

          ),
    );
  }
}