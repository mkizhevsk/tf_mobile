import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'dart:isolate';
//import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;
  //final IsolatedJod ani = new IsolatedJod();

  void startGeo() {
    _getCurrentLocation();
    asyncTask();
  }

  void _getCurrentLocation() async {
    Position position = await _determinePosition();

    print('position: ' + _position.toString());

    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Location Permissions are denied');
      }
    }

    //ani.main();
    //asyncTask();

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void asyncTask() async {
    print("start");

    /// Waits for this 5 seconds to elapse
    while (true) {
      final result = await Future.delayed(Duration(seconds: 5))
          .then((result) => _getCurrentLocation());
    }

    /// Then proceeds to run other lines of code
    /// While waiting, this does not block off other programs running
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocation App"),
      ),
      body: Center(
        child: _position != null
            ? Text('Current location ' + _position.toString())
            : Text('No location data'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: startGeo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class IsolatedJod {
//   void sayHi(String name) {
//     while (true) {
//       sleep(Duration(seconds: 3));
//       print('Isolate says Hi to $name');
//     }
//   }

//   Future<void> main() async {
//     print('Isolate start');
//     Isolate isolate = await Isolate.spawn(sayHi, 'mike');
//   }
// }


