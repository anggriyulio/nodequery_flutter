import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodequery_client/screens/account.dart';
import 'package:nodequery_client/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NodeQuery Client',
      theme: ThemeData(
        accentColor: Colors.black,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: MyBottomNavigationBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;

  _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    Home(),
    Account(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            title: Text('Servers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
        onTap: (int index) => _onNavigationTap(index),
      ),
    );
  }
}
