import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/utils/date_util.dart';

class HttpService {
  final String cardsUrl = 'https://mkizhevsk.ru/api';

  HttpService();

  Future<List<CardDTO>> syncCards(cards) async {
    //var mobileCards = cards.map((card) => CardDTO.toJson(card)).toList();
    var mobileCards =
        cards.map((card) => CardDTO.fromEntity(card).toJson()).toList();
    for (var card in mobileCards) {
      print(card);
    }

    final response = await http.post(
      Uri.parse('$cardsUrl/cards/sync'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(mobileCards),
    );

    String responseBody = utf8.decode(response.bodyBytes);
    print(responseBody);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(responseBody);
      List<CardDTO> cardDTOList =
          body.map((dynamic item) => CardDTO.fromJson(item)).toList();

      // List<CardEntity> cards = [];
      // for (var cardDTO in cardDTOList) {
      //   CardEntity card = CardEntity(
      //     internalCode: cardDTO.internalCode,
      //     editDateTime: DateUtil.stringToDateTime(cardDTO.editDateTime),
      //     front: cardDTO.front,
      //     back: cardDTO.back,
      //     example: cardDTO.example,
      //     status: cardDTO.status,
      //   );

      //   cards.add(card);
      // }
      // return cards;

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
