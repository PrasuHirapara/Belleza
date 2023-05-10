import 'package:belleza/Layouts/SideBar_Layouts/Profile.dart';
import 'package:belleza/Layouts/SideBar_Layouts/ReportBug.dart';
import 'package:belleza/auth/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../auth/ResetPassword.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingsState();
}

class _SettingsState extends State<Setting> {

  void signOut(){
    FirebaseAuth.instance.signOut().onError((error, stackTrace){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }

  void deleteAccount(String docId) async {
    try {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(docId);

      await FirebaseAuth.instance.currentUser!.delete();

      await documentReference.delete();
      print('Account deleted successfully.');
    } catch (e) {
      // Error message
      print('Error Deleting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Settings")),
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                  },
                  leading: Icon(Icons.perm_identity, size: 35, color: Colors.black,),
                  title: Text("\t\tProfile",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                ),
              ),
            ),

            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(),));
                  },
                  leading: Icon(Icons.lock_reset_outlined, size: 35, color: Colors.black,),
                  title: Text("\t\tReset Password",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                ),
              ),
            ),

            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportBug()));
                  },
                  leading: Icon(Icons.bug_report_outlined, size: 35, color: Colors.black,),
                  title: Text("\t\tReport Bug",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                ),
              ),
            ),

            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  onTap: (){
                    signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));},
                  leading: Icon(Icons.logout, size: 35, color: Colors.black,),
                  title: Text("\t\tLog Out",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                ),
              ),
            ),

            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  onTap: (){
                    deleteAccount(FirebaseAuth.instance.currentUser!.uid);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                  },
                  leading: Icon(Icons.delete_outline, size: 35, color: Colors.black,),
                  title: Text("\t\tDelete Account",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),

                ),
              ),
            ),

            SizedBox(height: 15,),

          ],
        ),
      ),
    );
  }
}
