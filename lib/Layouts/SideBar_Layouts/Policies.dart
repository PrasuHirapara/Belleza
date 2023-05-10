import 'package:flutter/material.dart';

class Policies extends StatelessWidget {
  const Policies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Policies")),
        ),
      ),
    );
  }
}
