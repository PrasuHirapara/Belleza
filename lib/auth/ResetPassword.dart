import 'package:belleza/Layouts/SideBar_Layouts/Setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String text_msg = "";
  String btn_msg = "send otp";
  String myOTP = "";
  String phoneNumber = "";
  bool OTP_sent = false;
  bool OTP_varified = false;
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final OTP_Controller = TextEditingController();
  final Phone_NumberController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

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
            verificationFailed: (FirebaseAuthException e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 2),));},
            codeSent: (String varificationId, int? resendToken) {
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
        ).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 1),));
        });
      }else{
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: myOTP,
          smsCode: OTP_Controller.text,
        );
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          await getUserPhoneNumber(FirebaseAuth.instance.currentUser!.uid);
          setState(() {
            btn_msg = "Reset password";
            OTP_varified = true;
          });
        });
      }
    }
  }

  Future<void> updatePassword(String newPassword) async {
    if(_formKey.currentState!.validate()){
      if(newPasswordController.text == confirmNewPasswordController.text){
        try {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            await user.updatePassword(newPassword)
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password Updated Successfully !'),duration: Duration(seconds: 1),));
            })
            .onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 2),));
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some error occurred !'),duration: Duration(seconds: 1),));
          }
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),duration: Duration(seconds: 3),));
        }
      }
    }
  }

  Future<void> updateFirebaseFirestore() async{
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'password' : newPasswordController.text,
    })
        .then((value) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Some error occurred !'),duration: Duration(seconds: 1),)); })
        .onError((error, stackTrace) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 1),));});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Reset Password")),
        ),
      ),
      body: OTP_varified?
      SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // App Logo
                  const Icon(Icons.lock_reset_outlined,size: 70),

                  const SizedBox(height: 25,),

                  // Welcome
                  Text("Set new Password",style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold),),

                  const SizedBox(height: 25,),

                  // Mobile number text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: newPasswordController,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Password';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "new password".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                            child: const Icon(Icons.visibility)
                        ),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: confirmNewPasswordController,
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Password';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "confirm new password".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: GestureDetector(
                            onTap: (){
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                            child: const Icon(Icons.visibility)
                        ),
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

                  const SizedBox(height: 20,),

                  // Send OTP
                  GestureDetector(
                    onTap: (){
                      setState(() async{
                        if(_formKey.currentState!.validate()){
                          if(newPasswordController.text == confirmNewPasswordController.text){
                            await updatePassword(newPasswordController.text);
                            await updateFirebaseFirestore();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Setting()));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Both Password must be same.'),duration: Duration(seconds: 1),));
                          }
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("set password".toUpperCase(),style: const TextStyle(color: Colors.white,fontSize: 18),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) :
      SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // App Logo
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.verified_user_outlined,size: 50),
                  ),

                  const SizedBox(height: 25,),

                  // Welcome
                  Text("Verifying via Mobile Number",style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold),),

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

                  // Mobile number text-field
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
                      varifyOTP(Phone_NumberController.text);
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
