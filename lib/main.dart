import 'package:flutter/material.dart';
import 'package:tf_mobile/screens/others.dart';
import 'screens/card_tab.dart';
import 'screens/contacts.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'dart:async';
import 'package:tf_mobile/services/app_initializer.dart';
import 'package:logging/logging.dart';
import 'package:tf_mobile/services/auth_service.dart';
import 'package:tf_mobile/screens/login_screen.dart';

void main() {
  _setupLogging();
  runApp(
    const MyApp(), //MaterialApp(home: MyHome()),
  );
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.loggerName}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create an instance of AuthService
    final authService = AuthService();

    return MaterialApp(
      home: FutureBuilder(
        future: authService.authenticate(), // Call the method on the instance
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("snapshot.hasError");
            return const LoginScreen(); // Navigate to the login screen if there's an error
          } else {
            return const MyHome(); // Navigate to the home screen if authentication is successful
          }
        },
      ),
    );
  }
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
