const String tableName = "tasks";

const String idField = "id";
const String titleField = "title";
const String descriptionField = "description";
const String dueDateField = "due_date";
const String isDoneField = "is_done";

const List<String> taskColumns = [
  idField,
  titleField,
  descriptionField,
  dueDateField,
  isDoneField,
];

const String bbolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";

class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final bool isDone;

  const Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.isDone,
  });

  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json[idField] as int?,
        title: json[titleField] as String,
        description: json[descriptionField] as String?,
        dueDate: DateTime.parse(json[dueDateField] as String),
        isDone: json[isDoneField] == 1,
      );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isDone,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        isDone: isDone ?? this.isDone,
      );
}
