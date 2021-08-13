import 'package:app/screens/welcome/index.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Color(0xffFF4A4A),
          accentColor: Color(0xffFF4A4A),
          fontFamily: "Poppins",
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white),
      home: MainWelcome(),
    );
  }
}
