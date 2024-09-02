import 'card.dart';

const String deckIdJsonName = "id";
const String deckNameJsonName = "name";
const String deckInternalCodeJsonName = "internal_code";
const String deckEditDateTimeJsonName = "edit_date_time";
const String deckDeletedJsonName = "deleted";
const String deckCardsJsonName = "cards";

class DeckEntity {
  int? id;
  late String name;
  late String internalCode;
  late DateTime editDateTime;
  bool deleted = false;
  List<CardEntity> cards = [];

  DeckEntity({
    this.id,
    required this.name,
    required this.internalCode,
    required this.editDateTime,
    this.deleted = false,
    this.cards = const [],
  });

  DeckEntity.empty();

  static DeckEntity fromJson(Map<String, dynamic> json) => DeckEntity(
        id: json[deckIdJsonName] as int?,
        name: json[deckNameJsonName] as String,
        internalCode: json[deckInternalCodeJsonName] as String,
        editDateTime: DateTime.parse(json[deckEditDateTimeJsonName] as String),
        deleted: json[deckDeletedJsonName] as bool? ?? false,
        cards: (json[deckCardsJsonName] as List<dynamic>?)
                ?.map((cardJson) => CardEntity.fromJson(cardJson))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        deckIdJsonName: id,
        deckNameJsonName: name,
        deckInternalCodeJsonName: internalCode,
        deckEditDateTimeJsonName: editDateTime.toIso8601String(),
        deckDeletedJsonName: deleted,
        deckCardsJsonName: cards.map((card) => card.toJson()).toList(),
      };

  DeckEntity copyWith({
    int? id,
    String? name,
    String? internalCode,
    DateTime? editDateTime,
    bool? deleted,
    List<CardEntity>? cards,
  }) =>
      DeckEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        internalCode: internalCode ?? this.internalCode,
        editDateTime: editDateTime ?? this.editDateTime,
        deleted: deleted ?? this.deleted,
        cards: cards ?? this.cards,
      );

  @override
  String toString() {
    return '$id, $name, $internalCode, $editDateTime, $deleted, Cards: [${cards.join(', ')}]';
  }
}
