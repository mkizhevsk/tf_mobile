import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/utils/date_util.dart';

class CardDTO {
  final String internalCode;
  final String editDateTime;
  final String front;
  final String back;
  final String example;
  final int status;

  CardDTO({
    required this.internalCode,
    required this.editDateTime,
    required this.front,
    required this.back,
    required this.example,
    required this.status,
  });

  factory CardDTO.fromJson(Map<String, dynamic> json) {
    return CardDTO(
      internalCode: json['internalCode'],
      editDateTime: json['editDateTime'],
      front: json['front'],
      back: json['back'],
      example: json['example'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'internalCode': internalCode,
      'editDateTime': editDateTime,
      'front': front,
      'back': back,
      'example': example,
      'status': status,
    };
  }

  static CardDTO fromEntity(CardEntity entity) {
    return CardDTO(
      internalCode: entity.internalCode,
      front: entity.front ?? '',
      back: entity.back ?? '',
      example: entity.example ?? '',
      status: entity.status ?? 0,
      editDateTime: DateUtil.dateTimeToString(entity.editDateTime),
    );
  }
}
