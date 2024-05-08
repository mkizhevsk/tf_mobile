//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tf_mobile/screens/others.dart';
//import 'package:flutter/widgets.dart';
import 'screens/cards.dart';
import 'screens/contacts.dart';

void main() {
  runApp(
    const MaterialApp(home: MyHome()),
  );
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  late int _currentIndex;

  List<Widget> body = [
    CardTab(),
    ContactTab(),
    OtherTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Cards',
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            label: 'Contacts',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Others',
            icon: Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
