import 'package:tf_mobile/services/http_service.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/utils/date_util.dart';

class AppInitializer {
  static void runAfterStart() {
    print('This runs after the app has started.');

    _fetchAndSyncCards();
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
    }
  }

  static Future<void> _syncCardsWithServer(List<CardEntity> localCards) async {
    final HttpService httpService = HttpService();

    try {
      List<CardDTO> webCardDtoList = await httpService.syncCards(localCards);
      print('webCards: $webCardDtoList');
      for (var wc in webCardDtoList) {
        print(wc);
      }

      for (var webCardDto in webCardDtoList) {
        print(
            'Web Card: ${webCardDto.internalCode}, ${webCardDto.front}, ${webCardDto.back}, ${webCardDto.example}, ${webCardDto.status}, ${webCardDto.editDateTime}');

        await _processCard(localCards, webCardDto);

        // bool isPresent = false;
        // CardEntity webCard = _createCardEntity(webCardDto);
        // CardEntity(
        //   internalCode: webCardDto.internalCode,
        //   editDateTime: DateUtil.stringToDateTime(webCardDto.editDateTime),
        //   front: webCardDto.front,
        //   back: webCardDto.back,
        //   example: webCardDto.example,
        //   status: webCardDto.status,
        // );

        // for (var localCard in localCards) {
        //   if (localCard.internalCode == webCard.internalCode) {
        //     isPresent = true;
        //     if (webCardDto.deleted) {
        //       var result = await AppDatabase.instance
        //           .deleteCardByInternalCode(localCard.internalCode);
        //       if (result > 0) {
        //         print(
        //             "card with internalCode ${webCard.internalCode} was deleted");
        //       }
        //     } else if (webCard.editDateTime.isAfter(localCard.editDateTime)) {
        //       await AppDatabase.instance.updateCard(webCard);
        //       print(
        //           'Updated local card with internalCode: ${webCard.internalCode}');
        //     }
        //     break;
        //   }
        // }

        // if (!isPresent) {
        //   await AppDatabase.instance.createCard(webCard);
        //   print('Created new card with internalCode: ${webCard.internalCode}');
        // }
      }
    } catch (error) {
      print('Error syncing cards with server: $error');
      // Handle error
    }
  }

  static Future<void> _processCard(
      List<CardEntity> localCards, CardDTO webCardDto) async {
    bool isPresent = false;
    CardEntity webCard = _createCardEntity(webCardDto);

    for (var localCard in localCards) {
      if (localCard.internalCode == webCard.internalCode) {
        isPresent = true;
        if (webCardDto.deleted) {
          await _deleteCard(localCard.internalCode);
        } else if (webCard.editDateTime.isAfter(localCard.editDateTime)) {
          await _updateCard(webCard);
        }
        break;
      }
    }

    if (!isPresent && !webCardDto.deleted) {
      await _createCard(webCard);
    }
  }

  static CardEntity _createCardEntity(CardDTO cardDto) {
    return CardEntity(
      internalCode: cardDto.internalCode,
      editDateTime: DateUtil.stringToDateTime(cardDto.editDateTime),
      front: cardDto.front,
      back: cardDto.back,
      example: cardDto.example,
      status: cardDto.status,
    );
  }

  static Future<void> _deleteCard(String internalCode) async {
    var result =
        await AppDatabase.instance.deleteCardByInternalCode(internalCode);
    if (result > 0) {
      print("Card with internalCode $internalCode was deleted");
    }
  }

  static Future<void> _updateCard(CardEntity webCard) async {
    await AppDatabase.instance.updateCard(webCard);
    print('Updated local card with internalCode: ${webCard.internalCode}');
  }

  static Future<void> _createCard(CardEntity webCard) async {
    await AppDatabase.instance.createCard(webCard);
    print('Created new local card with internalCode: ${webCard.internalCode}');
  }
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
