import 'package:belleza/auth/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Layouts/HomePage.dart';

class ForgotPassword extends StatefulWidget{
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String text_msg = "";
  String btn_msg = "send otp";
  String myOTP = "";
  String phoneNumber = "";
  bool OTP_sent = false;

  final _formKey = GlobalKey<FormState>();
  final Phone_NumberController = TextEditingController();
  final OTP_Controller = TextEditingController();

  Future<String> getUserPhoneNumber(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (documentSnapshot.exists) {
        phoneNumber = documentSnapshot.data()!['phone_number'];
      }
    } catch (e) {
      print('Error getting user phone number: $e');
    }
    return phoneNumber;
  }

  Future<void> varifyOTP(String number) async{
    if(_formKey.currentState!.validate()){
      if(!OTP_sent){
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: "+91"+number,
            verificationCompleted:
                (PhoneAuthCredential credentials) {},
            verificationFailed: (FirebaseAuthException e) {},
            codeSent: (String varificationId, int? resendToken) {
              print(myOTP);
              myOTP = varificationId;
              setState(() {
                if(_formKey.currentState!.validate()){
                  if(!OTP_sent){
                    text_msg = "otp sent via mobile number";
                    btn_msg = "verify otp";
                    OTP_sent = true;
                  }
                }
              });
            },
            codeAutoRetrievalTimeout: (String varificationId){}
        );}else{
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: myOTP,
          smsCode: OTP_Controller.text,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async{
          await getUserPhoneNumber(FirebaseAuth.instance.currentUser!.uid);
          if(phoneNumber.toString() == Phone_NumberController.text){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Login successfully!'),duration: Duration(seconds: 1),));
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mobile Number does not exist in Database'),duration: Duration(seconds: 1),));
          }
        })
            .onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 3),));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 20,),

                  // App Logo
                  const Icon(Icons.login_outlined,size: 50),

                  const SizedBox(height: 25,),

                  // Welcome
                  Text("Login via OTP",style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold),),

                  const SizedBox(height: 25,),

                  // Mobile number text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: Phone_NumberController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Number';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "registered phone number".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.password_outlined),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: OTP_Controller,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(OTP_sent){
                          if(value!.isEmpty){
                            return 'Enter a OTP';
                          }else{
                            return null;
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "otp".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.password_outlined),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  // Forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(text_msg.toUpperCase(),),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                  // Send OTP
                  GestureDetector(
                    onTap: () async{
                      await varifyOTP(Phone_NumberController.text);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text(btn_msg.toUpperCase(),style: const TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}