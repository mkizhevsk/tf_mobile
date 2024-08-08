import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;
import 'package:tf_mobile/database/app_database.dart';

class AuthService {
  final String tokenUrl = 'https://mkizhevsk.ru/api/refresh-token';

  AuthService();

  Future<void> authenticate() async {
    print("Start authenticate()");

    const String username = 'dvega2';
    const String password = 'password';

    // Retrieve the existing refresh token from the database
    final db = AppDatabase.instance;
    final tokenData = await db.getToken();
    // final refreshToken =
    //     "eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJzZWxmIiwic3ViIjoiZHZlZ2E0IiwiZXhwIjoxNzI1NDU3MTMzLCJpYXQiOjE3MjI4NjUxMzN9.TKqZ8dgLgThE26DpJULZ_9rfxsVMapsfUN4MtKpOnu6TQvAXza6snq4_fLtLWwXGm9JlWexuyqLrMAbvZqoktQeUioqJlFWppBSJ-aOIuWxCeY-v96PjCj6QzhofJ4NFqbnaRePPO7-VwVgo0WUGo1NFCQz3RIZP3qrDEvdYd06po5zuHY8C454l4_Ax-AZrHmjMAu4itcZfZ5H4Rqk1xy6LTcozzplNTuuYkwqEwbnlQBUztv347-KzCQdBMyo3pmYLANfLvtl7sidhA_bdvD-xrZbOi_H36W3XLlXxFk1RdCwpvfms8buFwCw9RqfdyeOuqGQDv9tMDXRIizGFCg";
    final refreshToken = tokenData?[constants.refreshTokenField];

    if (refreshToken == null) {
      throw Exception('No refresh token available for authentication');
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
      Map<String, dynamic> decodedToken = JwtDecoder.decode(newAccessToken);
      String expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)
              .toIso8601String();

      print("New access token expires at: $expiryDate");

      // Save the new tokens to the database
      final updatedTokenData = {
        constants.accessTokenField: newAccessToken,
        constants.refreshTokenField: newRefreshToken,
        constants.tokenTypeField: 'Bearer', // Assuming the token type is Bearer
        constants.expiryDateField: expiryDate,
      };

      await db.saveToken(updatedTokenData);
    } else {
      throw Exception('Failed to authenticate');
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
