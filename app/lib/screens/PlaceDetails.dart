import 'package:app/globals.dart';
import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

class PlaceDetails extends StatefulWidget {
  final Map place;
  const PlaceDetails({Key? key, required this.place}) : super(key: key);

  @override
  _PlaceDetailsState createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  bool loading = true;
  String address = "";

  @override
  void initState() {
    super.initState();

    convertCoords();

    // setState(() {
    //   loading = false;
    // });
  }

  void convertCoords() async {
    var ad = await placemarkFromCoordinates(
        double.parse(widget.place['lat']), double.parse(widget.place['long']));

    var realAd = ad[0];

    String text =
        "${realAd.name}, ${realAd.subLocality}, ${realAd.subAdministrativeArea}, ${realAd.administrativeArea}, ${realAd.postalCode}, ${realAd.country}";

    setState(() {
      address = text;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primary),
              ))
            : Container(
                child: SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider(
                        items: widget.place["image"].map<Widget>((i) {
                          return Container(
                            color: Colors.blue,
                            // margin: EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              i,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.4,
                            viewportFraction: 1.0,
                            autoPlayInterval: Duration(seconds: 10),
                            autoPlay: true)),
                    SizedBox(height: 20),
                    Text(
                      widget.place["name"],
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: grey900),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        widget.place["description"],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Color(0xff7A7A7A),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.6),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color(0xffD0D0D0),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(children: [
                        Icon(Icons.my_location, color: Color(0xff7A7A7A)),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(address,
                              style: TextStyle(
                                  color: Color(0xff7A7A7A),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                        )
                      ]),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Color(0xffD0D0D0),
                        thickness: 2,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Text("Average Rating",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: grey900)),
                          Expanded(
                            child: Container(),
                          ),
                          Text(widget.place['ratings'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: grey900))
                        ],
                      ),
                    ),
                    SizedBox(height: 90),
                  ],
                ),
              )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.directions_outlined),
          onPressed: () async {
            const platform =
                const MethodChannel("com.example.travelert/method_channel");

            try {
              var result = await platform.invokeMethod("openMaps",
                  {"lat": widget.place["lat"], "long": widget.place["long"]});
            } catch (e) {}
          },
        ),
      ),
    );
  }
}
