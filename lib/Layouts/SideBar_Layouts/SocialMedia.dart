import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  State<SocialMedia> createState() => _SocialMedia();
}

class _SocialMedia extends State<SocialMedia> {
  late String url = '';

  Future<void> _launchMaps(String _url) async {
    await launchUrlString(_url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Text("Social Media".toUpperCase()),
        )),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            InkWell(
              onTap: () {
                url = 'https://bellezaskinclinic.com/';
                _launchMaps(url);
                url = '';
              },
              child: Container(
                child: Image(image: AssetImage('assets/icons/website_logo.png')),
                width: MediaQuery.of(context).size.width/1.1,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                url = 'https://www.youtube.com/@bellezatheskinhairlaserclinic';
                _launchMaps(url);
                url = '';
              },
              child: Container(
                child: Image(image: AssetImage('assets/icons/yt_logo.png')),
                width: MediaQuery.of(context).size.width/1.1,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 15,),
            InkWell(
              onTap: () {
                url = 'https://www.instagram.com/dr.krishna_bhalala/';
                _launchMaps(url);
                url = '';
              },
              child: Container(
                child: Image(image: AssetImage('assets/icons/insta_logo.png')),
                width: MediaQuery.of(context).size.width/1.1,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 15,),
            InkWell(
              onTap: () {
                url = 'https://m.facebook.com/bellezaskinclinic';
                _launchMaps(url);
                url = '';
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Image(image: AssetImage('assets/icons/facebook_logo.png')),
                  width: MediaQuery.of(context).size.width/1.1,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
