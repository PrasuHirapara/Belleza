import 'package:belleza/Constants/Admin.dart';
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

        body:StreamBuilder(
           stream:
             FirebaseFirestore.instance
                 .collection("users")
                 .orderBy('timestamp',descending: true)
                 .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapShot){
              if(snapShot.hasData){
                 return ListView.builder(
                   scrollDirection: Axis.vertical,
                   itemCount: snapShot.data!.docs.length-1,
                   shrinkWrap: true,
                   itemBuilder: (context,i){
                     return Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: SingleChildScrollView(
                         scrollDirection: Axis.vertical,
                         child: Column(
                           children: [
                             SizedBox(height: 20,),

                             Container(
                               decoration: BoxDecoration(
                                   color: Colors.blueGrey[200],
                                   borderRadius: BorderRadius.circular(40)
                               ),
                               child: snapShot.data!.docs[i] == adminId ? null : ListTile(
                                 onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(title: snapShot.data!.docs[i]['user_uid'])));
                                   },
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
                               )
                             ),
                           ],
                         ),
                       ),
                     );
                   });
                  }
             else{
              return CircularProgressIndicator();
           }
        },
      ),
    );
  }
}