import 'package:belleza/SplashScreen.dart';
import 'package:belleza/auth/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  // Initializes Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Runs the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belleza',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
          titleTextStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,color: Colors.black),
          iconTheme: IconThemeData(color: Colors.black,size: 32),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,

        )
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
        if(snapshot.hasData){
          return SplashScreen();
        }else{
          return LoginPage();
        }
      }),
    );
  }
}