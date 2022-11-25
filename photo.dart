import 'package:flutter/material.dart';

class photo1 extends StatefulWidget {
  const photo1({Key? key}) : super(key: key);

  @override
  State<photo1> createState() => _photo1State();
}

class _photo1State extends State<photo1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/Placeholder.jpg"),
          ),
        ),
      ),
    );
  }
}
