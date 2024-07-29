const String cardIdJsonName = "id";
const String cardInternalCodeJsonName = "internal_code";
const String cardEditDateTimeJsonName = "edit_date_time";
const String cardFrontJsonName = "front";
const String cardBackJsonName = "back";
const String cardExampleJsonName = "example";
const String cardStatusJsonName = "status";

// const List<String> cardColumns = [
//   cardIdField,
//   cardInternalCodeField,
//   cardEditDateTimeField,
//   cardFrontField,
//   cardBackField,
//   cardExampleField,
//   cardStatusField,
// ];

class CardEntity {
  int? id;
  late String internalCode;
  late DateTime editDateTime;
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

  CardEntity.empty();

  static CardEntity fromJson(Map<String, dynamic> json) => CardEntity(
        id: json[cardIdJsonName] as int,
        internalCode: json[cardInternalCodeJsonName] as String,
        editDateTime: DateTime.parse(json[cardEditDateTimeJsonName] as String),
        front: json[cardFrontJsonName] as String?,
        back: json[cardBackJsonName] as String?,
        example: json[cardExampleJsonName] as String?,
        status: json[cardStatusJsonName] as int?,
      );

  Map<String, dynamic> toJson() => {
        cardIdJsonName: id,
        cardInternalCodeJsonName: internalCode,
        cardEditDateTimeJsonName: editDateTime.toIso8601String(),
        cardFrontJsonName: front,
        cardBackJsonName: back,
        cardExampleJsonName: example,
        cardStatusJsonName: status,
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
