import 'package:flutter/material.dart';
import 'package:tf_mobile/screens/others.dart';
import 'screens/card_tab.dart';
import 'screens/contacts.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'dart:async';
import 'package:tf_mobile/services/app_initializer.dart';

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

  StreamSubscription<int>? _cardIdSubscription;

  List<Widget> body = [
    const CardTab(),
    const ContactTab(),
    const OtherTab(),
  ];

  @override
  void initState() {
    print('initState of MyHomeState');
    super.initState();
    _currentIndex = 0;

    _cardIdSubscription = StreamManager().cardIdStream.listen((cardId) {
      setState(() {
        cardTabCardId = cardId;
        print('MyHomeState Received cardId: $cardId');
      });
    });

    // Schedule the method to run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppInitializer.runAfterStart();
    });
  }

  @override
  void dispose() {
    _cardIdSubscription?.cancel();
    super.dispose();
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
