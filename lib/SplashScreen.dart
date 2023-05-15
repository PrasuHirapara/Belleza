import 'dart:async';
import 'package:flutter/material.dart';
import 'Layouts/HomePage.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 150), () {
      setState(() {
        _isVisible = true;
      });
    });
    Timer(const Duration(milliseconds: 2850), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          child: Column(
            children: [

              const SizedBox(height: 50,),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                child: Container(
                  height: 650,
                  width: MediaQuery.of(context).size.width/1.2,
                  child: Image(
                    image: AssetImage('assets/icons/belleza_splash_logo.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}