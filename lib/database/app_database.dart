import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tf_mobile/model/task.dart';
import 'package:tf_mobile/model/card.dart';
import 'package:tf_mobile/assets/constants.dart' as constants;
// import 'package:tf_mobile/utils/string_random_generator.dart';

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
      CREATE TABLE $taskTableName (
        $taskIdField ${constants.idType},
        $taskTitleField ${constants.textType},
        $taskDescriptionField ${constants.textTypeNullable},
        $taskDueDateField ${constants.textType},
        $taskIsDoneField ${constants.boolType}
      )
    ''');
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

  Future<List<CardEntity>> getCards() async {
    final db = await instance.database;
    final result =
        await db.query(cardTableName, orderBy: "$cardEditDateTimeField DESC");
    return result.map((json) => CardEntity.fromJson(json)).toList();
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

  // Task
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(taskTableName, task.toJson());
    return task.copyWith(id: id);
  }

  Future<Task> getTask(int taskId) async {
    final db = await instance.database;
    final result =
        await db.query(taskTableName, where: 'id = ?', whereArgs: [taskId]);
    return result.map((json) => Task.fromJson(json)).first;
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result =
        await db.query(taskTableName, orderBy: "$taskDueDateField DESC");
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(
      taskTableName,
      task.toJson(),
      where: "$taskIdField = ?",
      whereArgs: [task.id],
    );
  }

  close() async {
    final db = await instance.database;
    return db.close;
  }
}
