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

const String boolType = "BOOLEAN NOT NULL";
const String idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
const String textTypeNullable = "TEXT";
const String textType = "TEXT NOT NULL";

class Task {
  int? id;
  String title;
  String? description;
  DateTime dueDate;
  bool isDone;

  Task({
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

  Map<String, dynamic> toJson() => {
        idField: id,
        titleField: title,
        descriptionField: description,
        dueDateField: dueDate.toIso8601String(),
        isDoneField: isDone ? 1 : 0,
      };

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

  @override
  String toString() {
    return '$id, $title, $description, $dueDate, $isDone';
  }
}
