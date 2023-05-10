import 'package:flutter/material.dart';

class Consultant extends StatelessWidget {
  const Consultant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Consultant")),
        ),
      ),
    );
  }
}
