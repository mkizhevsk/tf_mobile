import 'package:flutter/foundation.dart';

const String tableName = "card";

const String idField = "id";
const String internalCodeField = "internal_code";
const String editDateTimeField = "edit_date_time";
const String frontField = "front";
const String backField = "back";
const String exampleField = "example";
const String statusField = "status";

const List<String> cardColumns = [
  idField,
  internalCodeField,
  editDateTimeField,
  frontField,
  backField,
  exampleField,
  statusField,
];

const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";
const String intType = "INTEGER";

class Card {
  int? id;
  late String internalCode;
  late DateTime editDateTime;
  String? front;
  String? back;
  String? example;
  int? status;

  Card({
    this.id,
    required this.internalCode,
    required this.editDateTime,
    this.front,
    this.back,
    this.example,
    this.status,
  });

  static Card fromJson(Map<String, dynamic> json) => Card(
        id: json[idField] as int?,
        internalCode: json[internalCodeField] as String,
        editDateTime: DateTime.parse(json[editDateTimeField] as String),
        front: json[frontField] as String?,
        back: json[backField] as String?,
        example: json[exampleField] as String?,
        status: json[statusField] as int?,
      );

  Map<String, dynamic> toJson() => {
        idField: id,
        internalCodeField: internalCode,
        editDateTimeField: editDateTime.toIso8601String(),
        frontField: front,
        backField: back,
        exampleField: example,
        statusField: status,
      };

  Card copyWith({
    int? id,
    String? internalCode,
    DateTime? editDateTime,
    String? front,
    String? back,
    String? example,
    int? status,
  }) =>
      Card(
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
    return '$id, $internalCode, $, $dueDate, $isDone';
  }       
}
