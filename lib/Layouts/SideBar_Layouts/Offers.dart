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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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

            SizedBox(height: 300,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(child: Text("Book an Appointment".toUpperCase(),style: const TextStyle(color: Colors.white),)),
                  ),
                ),

                SizedBox(height: 5,),

                GestureDetector(
                  onTap: (){

                  },
                  child: Stack(
                    children: [
                      Container(
                        child: Icon(Icons.save_as_sharp,size: 40,),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: Text("  Save",style: TextStyle(fontWeight: FontWeight.w600),)),
                      )
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
