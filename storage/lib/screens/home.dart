import 'package:app/icons.dart';
import 'package:app/screens/tabs/music.dart';
import 'package:app/screens/tabs/sights.dart';
import 'package:app/screens/tabs/utilities.dart';
import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  List<Widget> screens = [Sights(), Utilities(), Music()];

  PageController _pgController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView(
            controller: _pgController,
            onPageChanged: (pageNum) {
              setState(() {
                _currentIndex = pageNum;
              });
            },
            children: screens,
          ),
          bottomNavigationBar: Container(
            height: 68,
            decoration: BoxDecoration(color: Color(0xffF5F7FA)),
            child: BottomNavigationBar(
              onTap: (i) {
                _currentIndex = i;
                _pgController.animateToPage(i,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear);
                setState(() {});
              },
              backgroundColor: Color(0xffF3F3F3),
              elevation: 0,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedItemColor: Theme.of(context).primaryColor,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      MyIcons.taj_mahal,
                      size: 28,
                    ),
                    // label: "Home",
                    title: Text("Sights",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w500))),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyIcons.food_fork_drink,
                      size: 28,
                    ),
                    // label: "Asanas",
                    title: Text("Utilities",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w500))),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyIcons.music,
                      size: 28,
                    ),
                    // label: "Asanas",
                    title: Text("Music",
                        style: TextStyle(
                            fontSize: 14.5, fontWeight: FontWeight.w500))),
              ],
            ),
          )),
    );
  }
}
