import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;

const String fileName = "tasks_database.db";

class AppDatabase {
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE $taskTableName (
    //     $taskIdField ${constants.idType},
    //     $taskTitleField ${constants.textType},
    //     $taskDescriptionField ${constants.textTypeNullable},
    //     $taskDueDateField ${constants.textType},
    //     $taskIsDoneField ${constants.boolType}
    //   )
    // ''');
    await db.execute('''
      CREATE TABLE $cardTableName (
        $cardIdField ${constants.idType},
        $cardInternalCodeField ${constants.textType},
        $cardEditDateTimeField ${constants.textType},
        $cardFrontField ${constants.textTypeNullable},
        $cardBackField ${constants.textTypeNullable},
        $cardExampleField ${constants.textTypeNullable},
        $cardStatusField ${constants.intTypeNullable}
      )
    ''');
  }

  Future<Database> _initializeDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Card
  Future<CardEntity> createCard(CardEntity card) async {
    final db = await instance.database;
    final id = await db.insert(cardTableName, card.toJson());
    return card.copyWith(id: id);
  }

  Future<CardEntity> getCard(int cardId) async {
    final db = await instance.database;
    final result =
        await db.query(cardTableName, where: 'id = ?', whereArgs: [cardId]);
    return result.map((json) => CardEntity.fromJson(json)).first;
  }

  Future<CardEntity> updateCard(CardEntity card) async {
    final db = await instance.database;
    await db.update(
      cardTableName,
      card.toJson(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
    return card;
  }

  Future<int> deleteCardByInternalCode(String internalCode) async {
    final db = await instance.database;
    return await db.delete(
      cardTableName,
      where: '$cardInternalCodeField = ?',
      whereArgs: [internalCode],
    );
  }

  Future<List<CardEntity>> getCards() async {
    final db = await instance.database;
    final result =
        await db.query(cardTableName, orderBy: "$cardEditDateTimeField DESC");
    return result.map((json) => CardEntity.fromJson(json)).toList();
  }

  Future<CardEntity> getCardToLearn() async {
    print('getCardToLearn');
    var cards = await getCards();
    print(cards.length);
    for (var card in cards) {
      print(card);
    }
    var currentDate = DateTime.now();
    var formattedCurrentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    var unlearnedCards = cards
        .where((card) => card.status == constants.cardIsNotLearned)
        .where((card) => !isSameDay(card.editDateTime, formattedCurrentDate))
        .toList();
    print(unlearnedCards.length);
    unlearnedCards.sort((a, b) => a.editDateTime.compareTo(b.editDateTime));
    if (unlearnedCards.isNotEmpty) {
      return unlearnedCards.first;
    } else {
      throw Exception('No unlearned cards available');
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<int> updateCardOld(CardEntity card) async {
    final db = await instance.database;
    return await db.update(
      cardTableName,
      card.toJson(),
      where: "$cardIdField = ?",
      whereArgs: [card.id],
    );
  }
}
