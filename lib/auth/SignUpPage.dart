import 'package:belleza/SplashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Layouts/HomePage.dart';
import 'GoogleSignUp_btn.dart';

class SignUpPage extends StatefulWidget{
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();
    String formattedDateTime = '$day-$month-$year';
    return formattedDateTime;
  }

  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userFirstNameController = TextEditingController();
  final userLastNameController = TextEditingController();
  final userNumberController = TextEditingController();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      late String currentDateTime = getCurrentDateTime();
        try {
          final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: userIdController.text,
              password: passwordController.text
          );
          final user = authResult.user;

          Map<String, dynamic> data = {
            "admin" : "false",
            "first_name": userFirstNameController.text,
            "last_name": userLastNameController.text,
            "email": userIdController.text,
            "password" : passwordController.text,
            "user_uid" : user!.uid.toString(),
            "phone_number": userNumberController.text,
            "registration_date" : currentDateTime,
            "message_time" : "00/00/000"
          };

          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(data)
          .then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User created successfully!'),duration: Duration(seconds: 1),));

        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
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
                const SizedBox(height: 50,),

                // Unlock Logo
                const Icon(Icons.lock,size: 50),

                const SizedBox(height: 25,),

                // Welcome
                Text("Welcome",style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold),),

                const SizedBox(height: 25,),

                // Username text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userFirstNameController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Name';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "name".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.perm_identity_outlined),
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

                  // Username text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userLastNameController,
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Last Name';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Surname".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.perm_identity_outlined),
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

                  // Id text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userIdController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Email';
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "email".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: Icon(Icons.mail_lock_outlined),
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

                  // Mobile number text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: userNumberController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter a Mobile No.';
                        }else{
                          return null;
                        }
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "mobile".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.phone),
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

                  // Password text-field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: passwordController,
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
                        hintText: "password".toUpperCase(),
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(Icons.password_outlined),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          child: const Icon(Icons.visibility),
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

                // Sign-Up
                GestureDetector(
                  onTap: (){
                    signUp();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("sign up".toUpperCase(),style: const TextStyle(color: Colors.white),)),
                  ),
                ),

                  const SizedBox(height: 20,),

                  const Center(child: Text("or Continue with")),

                  const SizedBox(height: 20,),

                  GoogleSignUp_btn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


