import 'package:app/globals.dart';
import 'package:app/screens/PlaceDetails.dart';
import "package:flutter/material.dart";

class PlaceCard extends StatefulWidget {
  final Map place;
  const PlaceCard({Key? key, required this.place}) : super(key: key);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => PlaceDetails()));
      },
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          height: 140,
          width: MediaQuery.of(context).size.width - 24,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffD0D0D0)))),
          // color: primary, hi
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  widget.place['image'][0],
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 140 - 24,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 24) -
                        24 -
                        22 -
                        MediaQuery.of(context).size.width * 0.3,
                    // color: Colors.red,
                    child: Text(widget.place['name'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: grey900,
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                  ),
                  Text(
                    "${widget.place['openTime']} - ${widget.place['closeTime']}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                        fontSize: 15),
                  ),
                  Expanded(child: Container()),
                  Container(
                    // color: Colors.red,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            // Expanded(child: Container()),
                            Text(
                              "5.0",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: grey900,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.star,
                          color: primary,
                          size: 26,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
