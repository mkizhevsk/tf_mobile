//import 'package:flutter/foundation.dart';

const String cardTableName = "card";

const String cardIdField = "id";
const String cardInternalCodeField = "internal_code";
const String cardEditDateTimeField = "edit_date_time";
const String cardFrontField = "front";
const String cardBackField = "back";
const String cardExampleField = "example";
const String cardStatusField = "status";

const List<String> cardColumns = [
  cardIdField,
  cardInternalCodeField,
  cardEditDateTimeField,
  cardFrontField,
  cardBackField,
  cardExampleField,
  cardStatusField,
];

// const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
// const String textTypeNullable = "TEXT";
// const String textType = "TEXT NOT NULL";
//

class CardEntity {
  int? id;
  String internalCode;
  DateTime editDateTime;
  String? front;
  String? back;
  String? example;
  int? status; // Состояние: 0 - не выучено, 1 - выучено

  CardEntity({
    this.id,
    required this.internalCode,
    required this.editDateTime,
    this.front,
    this.back,
    this.example,
    this.status,
  });

  static CardEntity fromJson(Map<String, dynamic> json) => CardEntity(
        id: json[cardIdField] as int?,
        internalCode: json[cardInternalCodeField] as String,
        editDateTime: DateTime.parse(json[cardEditDateTimeField] as String),
        front: json[cardFrontField] as String?,
        back: json[cardBackField] as String?,
        example: json[cardExampleField] as String?,
        status: json[cardStatusField] as int?,
      );

  Map<String, dynamic> toJson() => {
        cardIdField: id,
        cardInternalCodeField: internalCode,
        cardEditDateTimeField: editDateTime.toIso8601String(),
        cardFrontField: front,
        cardBackField: back,
        cardExampleField: example,
        cardStatusField: status,
      };

  CardEntity copyWith({
    int? id,
    String? internalCode,
    DateTime? editDateTime,
    String? front,
    String? back,
    String? example,
    int? status,
  }) =>
      CardEntity(
        id: id ?? this.id,
        internalCode: internalCode ?? this.internalCode,
        editDateTime: editDateTime ?? this.editDateTime,
        front: front ?? this.front,
        back: back ?? this.back,
        example: example ?? this.example,
        status: status ?? this.status,
      );

  @override
  String toString() {
    return '$id, $internalCode, $editDateTime, $front, $back, $example, $status';
  }
}
