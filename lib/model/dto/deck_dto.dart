import 'package:tf_mobile/model/entity/deck.dart';
import 'package:tf_mobile/model/dto/card_dto.dart';
import 'package:tf_mobile/utils/date_util.dart';

class DeckDTO {
  final String internalCode;
  final String editDateTime;
  final String name;
  final bool deleted;
  final List<CardDTO> cards;

  DeckDTO({
    required this.internalCode,
    required this.editDateTime,
    required this.name,
    required this.deleted,
    required this.cards,
  });

  factory DeckDTO.fromJson(Map<String, dynamic> json) {
    return DeckDTO(
      internalCode: json['internalCode'],
      editDateTime: json['editDateTime'],
      name: json['name'],
      deleted: json['deleted'] as bool,
      cards: (json['cards'] as List<dynamic>)
          .map((cardJson) => CardDTO.fromJson(cardJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'internalCode': internalCode,
      'editDateTime': editDateTime,
      'name': name,
      'deleted': deleted,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }

  static DeckDTO fromEntity(DeckEntity entity) {
    return DeckDTO(
      internalCode: entity.internalCode,
      name: entity.name,
      editDateTime: DateUtil.dateTimeToString(entity.editDateTime),
      deleted: entity.deleted,
      cards: entity.cards
          .map((cardEntity) => CardDTO.fromEntity(cardEntity))
          .toList(),
    );
  }
}
