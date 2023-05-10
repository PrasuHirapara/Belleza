import 'package:belleza/SplashScreen.dart';
import 'package:belleza/auth/ForgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Layouts/HomePage.dart';
import 'SignUpPage.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

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
                  const SizedBox(height: 40,),

                  Container(
                    height: 150,
                    child: Image(
                      image: AssetImage('assets/icons/belleza_logo.png'),
                    ),
                  ),

                  const SizedBox(height: 25,),

                  // Welcome
                  Text("Welcome",style: TextStyle(color: Colors.grey[700],fontSize: 16,fontWeight: FontWeight.bold),),

                  const SizedBox(height: 25,),

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
                          borderSide: BorderSide(color: Colors.grey.shade400),
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
                          borderSide: BorderSide(color: Colors.grey.shade400),
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
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(),));
                          },
                            child: const Text("Forgot Password",style: TextStyle(color: Colors.blue),)
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15,),

                  // Sign-in
                  GestureDetector(
                    onTap: (){
                      if(_formKey.currentState!.validate()){
                        try {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: userIdController.text,
                            password: passwordController.text)
                        .then((value){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Login successfully!'),duration: Duration(seconds: 1),));
                        }).then((value){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                        })
                        .onError((error, stackTrace){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),duration: Duration(seconds: 2),));
                        });
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),)));
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(child: Text("sign in".toUpperCase(),style: const TextStyle(color: Colors.white),)),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account ?"),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                          child: Text("Sign Up".toUpperCase(),style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                      ),
                    ],
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