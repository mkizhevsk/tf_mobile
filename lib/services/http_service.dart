import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/utils/date_util.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;
import 'package:tf_mobile/database/app_database.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HttpService {
  final String cardsUrl = 'https://mkizhevsk.ru/api';
  final String tokenUrl = 'https://mkizhevsk.ru/api/token';
  final String username = 'dvega2';
  final String password = 'password';

  HttpService();

  Future<void> authenticate() async {
    print("start authenticate()");

    final response = await http.post(
      Uri.parse(tokenUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$username:$password')),
      },
    );

    if (response.statusCode == 200) {
      print("here");
      final token = response.body
          .trim(); // Assuming the token is returned as a plain string
      print(token);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print(decodedToken);
      String expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000)
              .toIso8601String();

      print(expiryDate + token);

      final tokenData = {
        constants.accessTokenField: token,
        constants.refreshTokenField:
            '', // If your backend does not provide a refresh token, you can leave it empty
        constants.tokenTypeField: 'Bearer', // Assuming the token type is Bearer
        constants.expiryDateField:
            expiryDate.toString(), // Convert expiry date to String
      };

      // Save the token to the database
      final db = AppDatabase.instance;
      await db.saveToken(tokenData);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<List<CardDTO>> syncCards(cards) async {
    //var mobileCards = cards.map((card) => CardDTO.toJson(card)).toList();
    var mobileCards =
        cards.map((card) => CardDTO.fromEntity(card).toJson()).toList();
    for (var card in mobileCards) {
      print(card);
    }

    final db = AppDatabase.instance;
    final tokenData = await db.getToken();

    final response = await http.post(
      Uri.parse('$cardsUrl/cards/sync'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (tokenData != null)
          'Authorization': 'Bearer ${tokenData[constants.accessTokenField]}',
      },
      body: jsonEncode(mobileCards),
    );

    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(responseBody);
      List<CardDTO> cardDTOList =
          body.map((dynamic item) => CardDTO.fromJson(item)).toList();
      return cardDTOList;
    } else {
      throw Exception('Failed to load cards');
    }
  }

  Future<List<CardEntity>> getCards() async {
    final response = await http.get(
      Uri.parse('$cardsUrl/cards'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(responseBody);
      List<CardDTO> cardDTOList =
          body.map((dynamic item) => CardDTO.fromJson(item)).toList();

      List<CardEntity> cards = [];

      for (var cardDTO in cardDTOList) {
        CardEntity card = CardEntity(
          internalCode: cardDTO.internalCode,
          editDateTime: DateUtil.stringToDateTime(cardDTO.editDateTime),
          front: cardDTO.front,
          back: cardDTO.back,
          example: cardDTO.example,
          status: cardDTO.status,
        );

        cards.add(card);
      }

      return cards;
    } else {
      throw Exception('Failed to load cards');
    }
  }

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$cardsUrl$endpoint'));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$cardsUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$cardsUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$cardsUrl$endpoint'));

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
