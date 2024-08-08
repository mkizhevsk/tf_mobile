import 'package:flutter/material.dart';
import 'package:tf_mobile/services/auth_service.dart';
import 'package:tf_mobile/main.dart';
import 'package:tf_mobile/services/app_initializer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
