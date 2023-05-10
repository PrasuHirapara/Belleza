import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignUp_btn extends StatelessWidget{
  GoogleSignUp_btn({Key? key}) : super(key: key);

  final GoogleSignIn _GoogleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 200,
          color: Colors.red[500],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.g_mobiledata_outlined),

                 SizedBox(width: 10,),

                 MaterialButton(
                  onPressed: (){
                    _GoogleSignIn.signIn().then((value) {
                      String userName = value!.displayName!;
                      String profilePicture = value!.photoUrl!;
                    });
                  },
                  child: Text("google sign up".toUpperCase(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
    );
  }

}