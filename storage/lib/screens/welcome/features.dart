import 'package:app/globals.dart';
import 'package:app/screens/home.dart';
import 'package:app/widgets/button.dart';
import "package:flutter/material.dart";

class Features extends StatefulWidget {
  const Features({Key? key}) : super(key: key);

  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  List features = [
    {
      "name": "Alerts",
      "desc": "Get notified as soon as you are near a famous Tourist Spot",
      "img": "assets/alert.png"
    },
    {
      "name": "Search",
      "desc": "Search for tourist spots in place in the country",
      "img": "assets/search.png"
    },
    {
      "name": "Music",
      "desc": "Hear the regional music of the place you are visiting",
      "img": "assets/music.png"
    }
  ];

  PageController _pgs = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: PageView.builder(
          controller: _pgs,
          itemCount: features.length,
          itemBuilder: (context, index) {
            return Feature(
                name: features[index]["name"],
                desc: features[index]["desc"],
                img: features[index]["img"],
                onNext: () {
                  if (index != features.length - 1) {
                    _pgs.animateToPage(index + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Home()));
                  }
                });
          }),
    ));
  }
}

class Feature extends StatefulWidget {
  final String name, desc, img;
  final Function onNext;
  const Feature(
      {Key? key,
      required this.name,
      required this.desc,
      required this.img,
      required this.onNext})
      : super(key: key);

  @override
  _FeatureState createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Expanded(
          child: Container(),
        ),
        Image.asset(
          widget.img,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        SizedBox(height: 40),
        Text(
          widget.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: grey800, fontSize: 28, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(widget.desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff949494))),
        ),
        Expanded(
          child: Container(),
        ),
        LongButton(primary: true, onPress: widget.onNext, text: "Next"),
        SizedBox(
          height: 12,
        )
      ]),
    );
  }
}
