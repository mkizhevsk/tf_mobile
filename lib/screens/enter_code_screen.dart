import 'package:flutter/material.dart';
import 'package:tf_mobile/services/auth_service.dart';
import 'package:tf_mobile/services/card_sync_service.dart';
import 'package:tf_mobile/main.dart';

class EnterCodeScreen extends StatefulWidget {
  final String username;

  const EnterCodeScreen({Key? key, required this.username}) : super(key: key);

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final CardSyncService cardSyncService = CardSyncService();

  void _submitCode() async {
    if (_formKey.currentState!.validate()) {
      final String code = _codeController.text;
      // Handle code submission logic here
      print('Submitted code: $code');
      // Example: Call an authentication service with the code

      bool resultSuccessful =
          await _authService.processCode(widget.username, code);
      if (resultSuccessful) {
        await cardSyncService.fetchAndSyncCards();

        if (mounted) {
          // Navigate to MyHome screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MyHome(), // Ensure MyHome is imported
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Verification Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Please enter the verification code sent to your email:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the verification code';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCode,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
