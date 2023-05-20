import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class About extends StatefulWidget {
  About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String url = '';

  Future<void> _launchMaps(String _url) async {
    await launchUrlString(_url);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(right: 50),
          child: Center(child: Text("About")),
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
           children: [
            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width/1.1,
                height: 710,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5,),
                    Text("doctor".toUpperCase(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.2,
                        height: 300,
                        child: Hero(
                          tag: 'chatroomTOabout',
                            child: const Image(image: AssetImage('assets/icons/doctor.png'),)
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text("Name : Dr. Krishna Bhalala",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 20,),
                    const Text("Education : MBBS, DNB,     ",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 20,),
                    const Text("Expertise : Dermatology,     ",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
                    const Text("             : Hair Transplantation,",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 10,),
                    const Text("             : Cosmetic treatment",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 20,),
                    const Text("Experience : 7+ Years         ",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 20,),
                    const Text("Phone : +91 88497 74840 ",style: TextStyle(fontSize: 20),),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            url = 'https://bellezaskinclinic.com/';
                            _launchMaps(url);
                          },
                          child: Container(
                            child: const Image(image: AssetImage('assets/icons/website_logo.png')),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            url = 'https://www.instagram.com/dr.krishna_bhalala/';
                            _launchMaps(url);
                          },
                          child: Container(
                            child: const Image(image: AssetImage('assets/icons/insta_logo.png')),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            url = 'https://www.youtube.com/@bellezatheskinhairlaserclinic';
                            _launchMaps(url);
                          },
                          child: Container(
                            child: const Image(image: AssetImage('assets/icons/yt_logo.png')),
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
