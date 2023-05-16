import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  Offers({Key? key, this.title}) : super(key: key);

  final title;

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Offers")),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width/1.05,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 5,
                    color: Colors.black,
                  ),
                ],
              ),
              child: Hero(
                tag: 'home_TO_offers',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.title,
                    fit: BoxFit.cover,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
