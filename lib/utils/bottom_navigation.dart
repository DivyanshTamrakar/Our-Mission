import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../screens/history_screen.dart';
import '../screens/homescreen.dart';
import '../screens/profile_screen.dart';
import '../screens/solution_screen.dart';

class BottomBarExample extends StatefulWidget {
  @override
  _BottomBarExampleState createState() => new _BottomBarExampleState();
}

class _BottomBarExampleState extends State<BottomBarExample> {
  int _page = 0;
  PageController _controller;


  @override
  void initState() {
    _controller = new PageController(
      initialPage: _page,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 4,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.yellowAccent,
          backgroundColor: HomeScreen.color,
          currentIndex: _page,
          onTap: (index) {
            this._controller.animateToPage(index,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeInOut);
          },
          items:<BottomNavigationBarItem>[
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: "Home"),
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      label: "History"),
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.lightbulb,
                        color: Colors.white,
                      ),
                      label: "Solutions"),
                  new BottomNavigationBarItem(
                      icon: new Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: "Profile"),
                ]
        ),
      ),
      body: new PageView(
        controller: _controller,
        onPageChanged: (newPage) {
          setState(() {
            this._page = newPage;
          });
        },
        children: <Widget>[
          HomeScreen(),
          HistoryScreen(),
          SolutionScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
