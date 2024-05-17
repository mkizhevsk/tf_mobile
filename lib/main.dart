import 'package:flutter/material.dart';
import 'package:tf_mobile/screens/others.dart';
import 'screens/cards.dart';
import 'screens/contacts.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'dart:async';

void main() {
  runApp(
    const MaterialApp(home: MyHome()),
  );
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  late int _currentIndex;
  int cardTabCardId = 0;

  StreamSubscription<int>? _subscription;

  List<Widget> body = [
    const CardTab(),
    const ContactTab(),
    const OtherTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    print('initState of MyHomeState');
    _subscription = StreamManager().cardIdStream.listen((cardId) {
      setState(() {
        cardTabCardId = cardId;
        print('MyHomeState Received cardId: $cardId');
      });
    });
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
