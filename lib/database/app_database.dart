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
    await db.execute('''
      CREATE TABLE ${constants.cardTableName} (
        ${constants.cardIdField} ${constants.idType},
        ${constants.cardInternalCodeField} ${constants.textType},
        ${constants.cardEditDateTimeField} ${constants.textType},
        ${constants.cardFrontField} ${constants.textTypeNullable},
        ${constants.cardBackField} ${constants.textTypeNullable},
        ${constants.cardExampleField} ${constants.textTypeNullable},
        ${constants.cardStatusField} ${constants.intTypeNullable}
      )
    ''');

    await db.execute('''
      CREATE TABLE ${constants.tokenTableName} (
        ${constants.tokenIdField} ${constants.idType},
        ${constants.accessTokenField} ${constants.textType},
        ${constants.refreshTokenField} ${constants.textType},
        ${constants.tokenTypeField} ${constants.textType},
        ${constants.expiryDateField} ${constants.textType}
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
    final id = await db.insert(constants.cardTableName, card.toJson());
    return card.copyWith(id: id);
  }

  Future<CardEntity> getCard(int cardId) async {
    final db = await instance.database;
    final result = await db
        .query(constants.cardTableName, where: 'id = ?', whereArgs: [cardId]);
    return result.map((json) => CardEntity.fromJson(json)).first;
  }

  Future<CardEntity> updateCard(CardEntity card) async {
    final db = await instance.database;
    await db.update(
      constants.cardTableName,
      card.toJson(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
    return card;
  }

  Future<int> deleteCardByInternalCode(String internalCode) async {
    final db = await instance.database;
    return await db.delete(
      constants.cardTableName,
      where: '${constants.cardInternalCodeField} = ?',
      whereArgs: [internalCode],
    );
  }

  Future<List<CardEntity>> getCards() async {
    final db = await instance.database;
    final result = await db.query(constants.cardTableName,
        orderBy: "${constants.cardEditDateTimeField} DESC");
    return result.map((json) => CardEntity.fromJson(json)).toList();
  }

  Future<CardEntity> getCardToLearn() async {
    print('getCardToLearn');
    var cards = await getCards();
    print('cards to learn: ${cards.length}');
    // for (var card in cards) {
    //   print(card);
    // }
    var currentDate = DateTime.now();
    var formattedCurrentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    var unlearnedCards = cards
        .where((card) => card.status == constants.cardIsNotLearned)
        .where((card) => !isSameDay(card.editDateTime, formattedCurrentDate))
        .toList();
    print('unlearned cards: ${unlearnedCards.length}');
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

  Future<int> updateCardFromForm(CardEntity card) async {
    final db = await instance.database;
    return await db.update(
      constants.cardTableName,
      card.toJson(),
      where: "${constants.cardIdField} = ?",
      whereArgs: [card.id],
    );
  }

  // Token
  Future<void> saveToken(String accessToken, String refreshToken,
      String tokenType, String expiryDate) async {
    final db = await instance.database;
    await db.insert(constants.tokenTableName, {
      constants.accessTokenField: accessToken,
      constants.refreshTokenField: refreshToken,
      constants.tokenTypeField: tokenType,
      constants.expiryDateField: expiryDate,
    });
  }

  Future<Map<String, String>?> getToken() async {
    final db = await instance.database;
    final result = await db.query(constants.tokenTableName);
    if (result.isNotEmpty) {
      return {
        constants.accessTokenField:
            result.first[constants.accessTokenField] as String,
        constants.refreshTokenField:
            result.first[constants.refreshTokenField] as String,
        constants.tokenTypeField:
            result.first[constants.tokenTypeField] as String,
        constants.expiryDateField:
            result.first[constants.expiryDateField] as String,
      };
    }
    return null;
  }

  Future<void> deleteToken() async {
    final db = await instance.database;
    await db.delete(constants.tokenTableName);
  }
}
