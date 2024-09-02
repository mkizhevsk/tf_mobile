import 'package:tf_mobile/services/http_service.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/utils/date_util.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:tf_mobile/model/entity/deck.dart';

class CardSyncService {
  final Logger _logger = Logger('CardSyncService');
  final HttpService httpService = HttpService();

  Future<void> fetchAndSyncCards() async {
    try {
      List<DeckEntity> localDecks = await AppDatabase.instance.getDecks();
      _logger.info('Fetched ${localDecks.length} cards from local database');

      // Sync fetched cards with server
      await syncCardsWithServer(localDecks);
    } catch (error) {
      _logger.severe('Error fetching or syncing cards: $error');
    }
  }

  Future<void> syncCardsWithServer(List<DeckEntity> localDecks) async {
    try {
      List<CardDTO> webCardDtoList = await httpService.syncDecks(localDecks);
      _logger.info('Received webCardDtos: ${webCardDtoList.length}');

      for (var webCardDto in webCardDtoList) {
        _logger.fine(
            'Web Card: ${webCardDto.internalCode}, ${webCardDto.front}, ${webCardDto.back}, ${webCardDto.example}, ${webCardDto.status}, ${webCardDto.editDateTime}');

        await _processCard(localDecks, webCardDto);
      }
    } catch (error) {
      _logger.severe('Error syncing cards with server: $error');
    }
  }

  Future<void> _processCard(
      List<DeckEntity> localCards, CardDTO webCardDto) async {
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

  CardEntity _createCardEntity(CardDTO cardDto) {
    return CardEntity(
      internalCode: cardDto.internalCode,
      editDateTime: DateUtil.stringToDateTime(cardDto.editDateTime),
      front: cardDto.front,
      back: cardDto.back,
      example: cardDto.example,
      status: cardDto.status,
    );
  }

  Future<void> _deleteCard(String internalCode) async {
    var result =
        await AppDatabase.instance.deleteCardByInternalCode(internalCode);
    if (result > 0) {
      _logger.info("Card with internalCode $internalCode was deleted");
    }
  }

  Future<void> _updateCard(CardEntity webCard) async {
    await AppDatabase.instance.updateCard(webCard);
    _logger
        .info('Updated local card with internalCode: ${webCard.internalCode}');
  }

  Future<void> _createCard(CardEntity webCard) async {
    await AppDatabase.instance.createCard(webCard);
    _logger.info(
        'Created new local card with internalCode: ${webCard.internalCode}');
  }
}
