import 'dart:convert';

import 'package:app/globals.dart';
import 'package:app/widgets/MusicCard.dart';
import "package:flutter/material.dart";
import 'package:flutter_typeahead/flutter_typeahead.dart';
import "package:app/data/districts.dart";
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import "package:http/http.dart" as http;

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);
  
  @override
  _MusicState createState() => _MusicState();
  
}

class _MusicState extends State<Music> {
  bool searched = false;
  bool isLoading = false;
  String hintText = "Search for a city...";

  int? districtId;
  String? districtName;

  List places = [];

  List PopularPlaces = [];

  TextEditingController _searchController = TextEditingController();

  Future<dynamic> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showToast("GPS is turned off");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showToast("Location Permissions denied");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showToast(
          "Locations Permissions are denied. Please change them in phone settings.");
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void showToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xff323232),
      content: Container(
        height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: TextStyle(
                    color: Color(0xffE4E7EB),
                    fontWeight: FontWeight.w500,
                    fontSize: 17)),
          ],
        ),
      ),
    ));
  }

  void getPlaces(int id) async {
    print(id);
    var res = await http.get(Uri.parse("$baseUrl/api/music/$id"));
    print(res.body);
    setState(() {
      isLoading = false;
      places = jsonDecode(res.body);
    });
  }

  @override
  void initState(){
     super.initState();
     void getPopularPlaces() async {
      var res = await http.get(Uri.parse("$baseUrl/api/music/popular"));
      print(res.body);
      setState(() {
        isLoading = false;
        PopularPlaces = jsonDecode(res.body);
      });
    }
    getPopularPlaces();
}

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
              ),
              SizedBox(
                height: 20,
              ),
              TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      cursorColor: primary,
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search for a city...",
                          hintStyle: TextStyle(
                            color: Color(0xffA1A1A1),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Color(0xffCFCFCF), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: primary, width: 2),
                          ))),
                  noItemsFoundBuilder: (context) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
                        child: Text("No cities found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: grey700)),
                      ),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    // print(pattern);
                    List suggestions = [];
                    districts.forEach((element) {
                      if (element['name']
                          .toLowerCase()
                          .contains(pattern.toLowerCase())) {
                        suggestions.add(element);
                      }
                    });
                    return suggestions;
                  },
                  itemBuilder: (context, suggestion) {
                    // print(suggestion);
                    return ListTile(title: Text((suggestion as Map)['name']));
                  },
                  onSuggestionSelected: (suggestion) async {
                    setState(() {
                      isLoading = true;
                      searched = true;
                      districtId = (suggestion as Map)['id'];
                    });
                    _searchController.text = (suggestion as Map)['name'];
                    getPlaces((suggestion)['id']);
                  }),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  var latLng = await _determinePosition();
                  print(latLng);
                  var place = await placemarkFromCoordinates(
                      latLng.latitude, latLng.longitude);
                  print(place[0].postalCode);
                  var res = await http.get(Uri.parse(
                      "$baseUrl/api/toDistrict/${place[0].postalCode}"));
                  var body = jsonDecode(res.body);
                  _searchController.text = body['district_name'];
                  setState(() {
                    hintText = body['district_name'];
                    searched = true;
                    districtId = body['district_id'];
                    districtName = body['district_name'];
                  });
                  getPlaces(body['district_id']);
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Use Current Location",
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.w500)),
                ]),
              ),
              isLoading
                  ? Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 300),
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(primary))))
                  : !searched
                      ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text('Popular', 
                                    style: TextStyle(
                                      color: grey900,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [ 
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                                      child: Image.network("http://travelertapi.herokuapp.com/cdn/india_gate.png"),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue[800]),
                                        ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                                      child: Image.network("http://travelertapi.herokuapp.com/cdn/taj_mahal.png"),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.red),
                                        ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [ 
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                                      child: Image.network("http://travelertapi.herokuapp.com/cdn/india_gate.png"),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.orange),
                                        ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                                      child: Image.network("http://travelertapi.herokuapp.com/cdn/taj_mahal.png"),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.purple),
                                        ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                      : places.length == 0
                          ? Container(
                              color: Colors.red,
                              constraints: BoxConstraints(
                                  minHeight:
                                      MediaQuery.of(context).size.height - 300),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(),
                                  Image.asset(
                                    "assets/alert.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                  SizedBox(height: 24),
                                  Text("No places found",
                                      style: TextStyle(
                                        color: grey900,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ))
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                // SizedBox(height: 20),
                                Container(
                                  child: Column(
                                    children: places.map((p) {
                                      return MusicCard(place: p);
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            )
            ],
          ),
        ),
      ),
    );
  }
}
