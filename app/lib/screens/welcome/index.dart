import 'package:app/globals.dart';
import 'package:app/screens/welcome/features.dart';
import 'package:app/widgets/button.dart';
import "package:flutter/material.dart";

class MainWelcome extends StatefulWidget {
  const MainWelcome({Key? key}) : super(key: key);

  @override
  _MainWelcomeState createState() => _MainWelcomeState();
}

class _MainWelcomeState extends State<MainWelcome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(),
            ),
            Image.asset("assets/logo.png"),
            SizedBox(height: 40),
            Text(
              "Travelert",
              style: TextStyle(
                  color: grey800, fontSize: 30, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Container(),
            ),
            LongButton(
                primary: true,
                onPress: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Features()));
                },
                text: "Get Started"),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}
