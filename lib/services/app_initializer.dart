import 'package:tf_mobile/services/card_sync_service.dart';
import 'dart:async';
import 'package:logging/logging.dart';

class AppInitializer {
  static final Logger _logger = Logger('AppInitializer');
  static final Completer<void> _initializerCompleter = Completer<void>();
  static final CardSyncService _cardSyncService = CardSyncService();

  static Future<void> runAfterStart() async {
    if (!_initializerCompleter.isCompleted) {
      _logger.info('This runs after the app has started.');
      await _cardSyncService.fetchAndSyncCards();
      _initializerCompleter.complete();
    }
    await _initializerCompleter.future;
  }
}
// class AppInitializer {
//   static final Logger _logger = Logger('AppInitializer');
//   static final Completer<void> _initializerCompleter = Completer<void>();

//   static Future<void> runAfterStart() async {
//     if (!_initializerCompleter.isCompleted) {
//       _logger.info('This runs after the app has started.');
//       await _fetchAndSyncCards();
//       _initializerCompleter.complete();
//     }
//     await _initializerCompleter.future;
//   }

//   static Future<void> _fetchAndSyncCards() async {
//     try {
//       List<CardEntity> localCards = await AppDatabase.instance.getCards();
//       _logger.info('Fetched ${localCards.length} cards from local database');
//       // for (var card in localCards) {
//       //   _logger.fine(card);
//       // }

//       // Sync fetched cards with server
//       await _syncCardsWithServer(localCards);
//     } catch (error) {
//       _logger.severe('Error fetching or syncing cards: $error');
//     }
//   }

//   static Future<void> _syncCardsWithServer(List<CardEntity> localCards) async {
//     final HttpService httpService = HttpService();

//     try {
//       List<CardDTO> webCardDtoList = await httpService.syncCards(localCards);
//       _logger.info('received webCardDtos: ${webCardDtoList.length}');
//       // for (var wc in webCardDtoList) {
//       //   _logger.fine(wc);
//       // }

//       for (var webCardDto in webCardDtoList) {
//         _logger.fine(
//             'Web Card: ${webCardDto.internalCode}, ${webCardDto.front}, ${webCardDto.back}, ${webCardDto.example}, ${webCardDto.status}, ${webCardDto.editDateTime}');

//         await _processCard(localCards, webCardDto);
//       }
//     } catch (error) {
//       _logger.severe('Error syncing cards with server: $error');
//       // Handle error
//     }
//   }

//   static Future<void> _processCard(
//       List<CardEntity> localCards, CardDTO webCardDto) async {
//     bool isPresent = false;
//     CardEntity webCard = _createCardEntity(webCardDto);

//     for (var localCard in localCards) {
//       if (localCard.internalCode == webCard.internalCode) {
//         isPresent = true;
//         if (webCardDto.deleted) {
//           await _deleteCard(localCard.internalCode);
//         } else if (webCard.editDateTime.isAfter(localCard.editDateTime)) {
//           await _updateCard(webCard);
//         }
//         break;
//       }
//     }

//     if (!isPresent && !webCardDto.deleted) {
//       await _createCard(webCard);
//     }
//   }

//   static CardEntity _createCardEntity(CardDTO cardDto) {
//     return CardEntity(
//       internalCode: cardDto.internalCode,
//       editDateTime: DateUtil.stringToDateTime(cardDto.editDateTime),
//       front: cardDto.front,
//       back: cardDto.back,
//       example: cardDto.example,
//       status: cardDto.status,
//     );
//   }

//   static Future<void> _deleteCard(String internalCode) async {
//     var result =
//         await AppDatabase.instance.deleteCardByInternalCode(internalCode);
//     if (result > 0) {
//       _logger.info("Card with internalCode $internalCode was deleted");
//     }
//   }

//   static Future<void> _updateCard(CardEntity webCard) async {
//     await AppDatabase.instance.updateCard(webCard);
//     _logger
//         .info('Updated local card with internalCode: ${webCard.internalCode}');
//   }

//   static Future<void> _createCard(CardEntity webCard) async {
//     await AppDatabase.instance.createCard(webCard);
//     _logger.info(
//         'Created new local card with internalCode: ${webCard.internalCode}');
//   }
// }
