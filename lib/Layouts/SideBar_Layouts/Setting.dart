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
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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

      await documentReference.delete()
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account deleted successfully."),duration: Duration(seconds: 2),));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 3),));
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
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(25)
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
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(25)
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
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(25)
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
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: ListTile(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                        title: Text('Log Out',style: TextStyle(fontSize: 30),),
                        content: Text('Are you sure want to Log Out ?',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('NO'),
                          ),
                          TextButton(
                            onPressed: () {
                                signOut();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                              },
                            child: Text('YES'),
                          ),
                        ],
                       )
                    );
                  },
                  leading: Icon(Icons.logout, size: 35, color: Colors.black,),
                  title: Text("\t\tLog Out",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
                ),
              ),
            ),

            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: ListTile(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Delete Account',style: TextStyle(fontSize: 30),),
                        content: Text('Are you sure want to Delete Account ?',style: TextStyle(fontSize: 17),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('NO'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteAccount(FirebaseAuth.instance.currentUser!.uid);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                            },
                            child: Text('YES'),
                          ),
                        ],
                     )
                    );
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
