import 'package:app/globals.dart';
import "package:flutter/material.dart";

class MusicCard extends StatefulWidget {
  final Map place;
  const MusicCard({Key? key, required this.place}) : super(key: key);

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: 
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color(int.parse("0xff${widget.place['color']}")),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Image.network("$baseUrl${widget.place['image']}"),
              ),
              Text(
                widget.place['name'], 
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20)
                ),
            ],
          ),
        ),
          );
  }
}
