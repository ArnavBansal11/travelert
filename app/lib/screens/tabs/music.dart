import 'package:app/globals.dart';
import "package:flutter/material.dart";

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Music",
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 30, color: grey800),
              )
            ],
          ),
        ),
      ),
    );
  }
}
