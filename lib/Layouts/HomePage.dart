import 'package:belleza/Layouts/SideBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static String first_name = "";
  static String last_name = "";
  static String email = "";
  static String phone_number = "";
  static String uid = "";
  static String registration_date = "";
  static bool isAdmin = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      drawer: SideBar(),

      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(right: 50),
            child: Center(child: Text("belleza".toUpperCase(),style: TextStyle(fontSize: 25,color: Colors.black),))
        ),
      ),
      body: Container(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPopupMenu(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showPopupMenu(BuildContext context) async {
    String? selectedValue = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(25.0, 0, 0.0, 2.0),
      items: [
        PopupMenuItem(
          child: Text("Option 1"),
          value: "Option 1",
        ),
        PopupMenuItem(
          child: Text("Option 2"),
          value: "Option 2",
        ),
        PopupMenuItem(
          child: Text("Option 3"),
          value: "Option 3",
        ),
      ],
      elevation: 8.0,
    );

    if (selectedValue != null) {
      print("Selected value: $selectedValue");
    }
  }
}