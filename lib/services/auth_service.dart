import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;
import 'package:tf_mobile/database/app_database.dart';

class AuthService {
  final String tokenUrl = 'https://mkizhevsk.ru/api/token';

  AuthService();

  Future<void> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    if (response.statusCode == 200) {
      final token = response.body.trim();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)
              .toIso8601String();

      final tokenData = {
        constants.accessTokenField: token,
        constants.expiryDateField: expiryDate.toString(),
      };

      final db = AppDatabase.instance;
      await db.saveToken(tokenData);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  static Future<bool> isAuthenticated() async {
    final db = AppDatabase.instance;
    final token = await db.getToken();
    if (token != null) {
      final expiryDate = DateTime.parse(token[constants.expiryDateField]!);
      return DateTime.now().isBefore(expiryDate);
    }
    return false;
  }

  static Future<String?> getAccessToken() async {
    final db = AppDatabase.instance;
    final token = await db.getToken();
    return token?[constants.accessTokenField];
  }
}
