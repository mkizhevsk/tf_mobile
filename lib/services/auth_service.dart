import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;
import 'package:tf_mobile/database/app_database.dart';

class AuthService {
  final String tokenUrl = 'https://mkizhevsk.ru/api/refresh-token';

  AuthService();

  Future<bool> authenticate() async {
    print("Start authenticate()");

    const String username = 'dvega2';
    const String password = 'password';

    // Retrieve the existing refresh token from the database
    final db = AppDatabase.instance;
    final tokenData = await db.getToken();
    final refreshToken =
        "eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJzZWxmIiwic3ViIjoiZHZlZ2E0IiwiZXhwIjoxNzI1ODA0MTI0LCJpYXQiOjE3MjMyMTIxMjR9.vnwMqBfZynFsOkwT2jwPpeTAGY7pkzy7sXZ-jHhDcbjdnNJ6-YNXnTB38qlBBNs_LST556R7ekp9rlWNJ50Sf6qG5La9KMik-SKKDAh2nS8Tw36mH2B0ATvAyTpKxVgCLEpwnerAuS9vUYrV9BKviSsLJE7FSVLRX4M4pU-h5uzATN5Qc67yItwlYiqTpjbAxRHh-gZW8Yo8DFaWXP0PMDCt9OBp_zabIqVsH47CV_fMsbtzg-1oy4VlSeSG32alv7EK3GGb4qDTgixcG0_Lyk7vYaj8_T1eWU3dXHuib3fQnJI-mV3QOP7R0zSXQPQmISazZxB5lcHPwpAflG-pSA";
    // final refreshToken = tokenData?[constants.refreshTokenField];

    if (refreshToken == null) {
      // Return false to indicate that there's no refresh token and authentication failed
      return false;
    }

    // Send the refresh token to get new tokens
    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      print("Authentication successful");
      final Map<String, dynamic> tokens = jsonDecode(response.body);
      final String newAccessToken = tokens['accessToken'].trim();
      final String newRefreshToken = tokens['refreshToken'].trim();

      // Decode the access token to extract the expiration date
      Map<String, dynamic> decodedToken = JwtDecoder.decode(newRefreshToken);
      String expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)
              .toIso8601String();

      print("New refresh token expires at: $expiryDate");

      // Save the new tokens to the database
      final updatedTokenData = {
        constants.accessTokenField: newAccessToken,
        constants.refreshTokenField: newRefreshToken,
        constants.tokenTypeField: 'Bearer', // Assuming the token type is Bearer
        constants.expiryDateField: expiryDate,
      };
      await db.saveToken(updatedTokenData);

      return true; // Authentication successful
    } else {
      print('Failed to authenticate');
      return false;
    }
  }
}

// class AuthService {
//   final String tokenUrl = 'https://mkizhevsk.ru/api/refresh-token';

//   AuthService();

//   Future<void> authenticate() async {
//     print("start authenticate()");
//     const String username = 'dvega2';
//     const String password = 'password'; 

//     final response = await http.post(
//       Uri.parse(tokenUrl),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization':
//             'Basic ' + base64Encode(utf8.encode('$username:$password')),
//       },
//     );

//     if (response.statusCode == 200) {
//       print("here");
//       final token = response.body
//           .trim(); // Assuming the token is returned as a plain string
//       print(token);
//       Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
//       print(decodedToken);
//       String expiryDate =
//           DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)
//               .toIso8601String();

//       print(expiryDate + token);

//       final tokenData = {
//         constants.accessTokenField: token,
//         constants.refreshTokenField:
//             '', // If your backend does not provide a refresh token, you can leave it empty
//         constants.tokenTypeField: 'Bearer', // Assuming the token type is Bearer
//         constants.expiryDateField:
//             expiryDate.toString(), // Convert expiry date to String
//       };

//       // Save the token to the database
//       final db = AppDatabase.instance;
//       await db.saveToken(tokenData);
//     } else {
//       throw Exception('Failed to authenticate');
//     }
//   }
// }
