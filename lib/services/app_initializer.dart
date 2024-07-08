import 'package:flutter/material.dart';
import 'package:tf_mobile/services/http_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/database/app_database.dart';

class AppInitializer {
  static void runAfterStart() {
    print('This runs after the app has started.');
    final HttpService httpService = HttpService();

    _fetchAndSyncCards();

    // httpService.getCards().then((cards) {
    //   for (var card in cards) {
    //     print(
    //         'Card: ${card.internalCode}, ${card.front}, ${card.back}, ${card.example}, ${card.status}, ${card.editDateTime}');
    //   }

    //   var card1 = cards[1];
    //   String cardData =
    //       'Card: ${card1.internalCode}, ${card1.front}, ${card1.back}, ${card1.example}, ${card1.status}, ${card1.editDateTime}';
    //   //print(cardData);
    //   Fluttertoast.showToast(
    //     msg: cardData,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }).catchError((error) {
    //   print('Error: $error');
    // });
  }

  static void _fetchAndSyncCards() async {
    try {
      List<CardEntity> localCards = await AppDatabase.instance.getCards();
      print('Fetched ${localCards.length} cards from local database.');

      for (var card in localCards) {
        print(card);
      }

      // Sync fetched cards with server
      await _syncCardsWithServer(localCards);
    } catch (error) {
      print('Error fetching or syncing cards: $error');
      // Handle error
    }
  }

  static Future<void> _syncCardsWithServer(List<CardEntity> localCards) async {
    final HttpService httpService = HttpService();

    try {
      List<CardEntity> webCards = await httpService.syncCards(localCards);

      for (var webCard in webCards) {
        print(
            'Web Card: ${webCard.internalCode}, ${webCard.front}, ${webCard.back}, ${webCard.example}, ${webCard.status}, ${webCard.editDateTime}');

        bool isPresent = false;
        for (var localCard in localCards) {
          if (localCard.internalCode == webCard.internalCode &&
              webCard.editDateTime.isAfter(localCard.editDateTime)) {
            isPresent = true;
            await AppDatabase.instance.updateCard(webCard);
            print(
                'Updated local card with internalCode: ${webCard.internalCode}');
            break;
          }
        }

        if (!isPresent) {
          await AppDatabase.instance.createCard(webCard);
          print('Created new card with internalCode: ${webCard.internalCode}');
        }

        // Display toast for each synced card
        // String cardData =
        //     'Synced Card: ${card.internalCode}, ${card.front}, ${card.back}, ${card.example}, ${card.status}, ${card.editDateTime}';
        // Fluttertoast.showToast(
        //   msg: cardData,
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.black,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
      }
    } catch (error) {
      print('Error syncing cards with server: $error');
      // Handle error
    }
  }
}
