import 'package:tf_mobile/services/http_service.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/utils/date_util.dart';
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:tf_mobile/model/entity/deck.dart';
import 'package:tf_mobile/model/dto/deck_dto.dart';

class CardSyncService {
  final Logger _logger = Logger('CardSyncService');
  final HttpService httpService = HttpService();

  Future<void> fetchAndSyncCards() async {
    try {
      List<DeckEntity> localDecks = await AppDatabase.instance.getDecks();
      _logger.info('Fetched ${localDecks.length} cards from local database');

      // create List<DeckDTO>

      // Sync fetched cards with server
      await syncDecksWithServer(localDecks);
    } catch (error) {
      _logger.severe('Error fetching or syncing cards: $error');
    }
  }

  Future<void> syncDecksWithServer(List<DeckEntity> localDecks) async {
    try {
      var localDeckDTOs = await getLocalDeckDTOs(localDecks);

      List<DeckDTO> webDeckDtoList = await httpService.syncDecks(localDeckDTOs);
      _logger.info('Received webDeckDtos: ${webDeckDtoList.length}');

      for (var webDeckDto in webDeckDtoList) {
        _logger.fine(
            'WebDeckDto: ${webDeckDto.name}, ${webDeckDto.internalCode}, ${webDeckDto.editDateTime}, ${webDeckDto.cards.length}, ${webDeckDto.deleted}');

        await _processDeck(localDecks, webDeckDto);
      }

      await _processWebCards(webDeckDtoList);
    } catch (error) {
      _logger.severe('Error syncing decks with server: $error');
    }
  }

  Future<List<DeckDTO>> getLocalDeckDTOs(List<DeckEntity> localDecks) async {
    List<DeckDTO> localDeckDTOs = [];

    // some logic here

    return localDeckDTOs;
  }

  Future<void> _processDeck(
      List<DeckEntity> localDecks, DeckDTO webDeckDto) async {
    print("_processDeck");
    var webDeckEditDateTime =
        DateUtil.stringToDateTime(webDeckDto.editDateTime);
    bool isPresent = false;
    //DeckEntity webDeck = _createDeckEntity(webDeckDto);

    for (var localDeck in localDecks) {
      if (localDeck.internalCode == webDeckDto.internalCode) {
        isPresent = true;
        if (webDeckDto.deleted) {
          // If the deck is marked as deleted, remove it from the local database
          print("_deleteDeck");
          await _deleteDeck(localDeck.internalCode);
        } else if (webDeckEditDateTime.isAfter(localDeck.editDateTime)) {
          print("_updateDeck");
          // If the server's version is newer, update the local deck
          await _updateDeck(webDeckDto);
        }
        print("break");
        break;
      }
    }

    if (!isPresent && !webDeckDto.deleted) {
      // If the deck is not present and not deleted, create a new one
      await _createDeck(webDeckDto, webDeckEditDateTime);
    }
  }

  Future<void> _deleteDeck(String internalCode) async {
    // Implement logic to delete the deck from the local database using the internalCode
  }

  Future<void> _updateDeck(DeckDTO deck) async {
    // Implement logic to update the deck in the local database
  }

  Future<void> _createDeck(DeckDTO deckDTO, DateTime editDateTime) async {
    try {
      var deckEntity = DeckEntity(
        name: deckDTO.name,
        internalCode: deckDTO.internalCode,
        editDateTime: editDateTime,
      );
      await AppDatabase.instance.createDeck(deckEntity);
      _logger.info('Deck created with internalCode: ${deckDTO.internalCode}');
    } catch (error) {
      _logger.severe(
          'Error creating deck with internalCode: ${deckDTO.internalCode}. Error: $error');
    }
  }

  Future<void> _processWebCards(List<DeckDTO> webDeckDtoList) async {
    List<CardEntity> localCards = await AppDatabase.instance.getCards();
    _logger.info('Fetched ${localCards.length} cards from local database');

    for (var webDeckDto in webDeckDtoList) {
      for (var webCardDto in webDeckDto.cards) {
        await _processCard(localCards, webCardDto, webDeckDto.internalCode);
      }
    }
  }

  Future<void> _processCard(List<CardEntity> localCards, CardDTO webCardDto,
      String deckInternalCode) async {
    DeckEntity deck =
        await AppDatabase.instance.getDeckByInternalCode(deckInternalCode);
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
      await _createCard(webCard, deck.id!);
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

  Future<void> _createCard(CardEntity webCard, int deckId) async {
    await AppDatabase.instance.createCard(webCard);
    _logger.info(
        'Created new local card with internalCode: ${webCard.internalCode}');
  }
}
