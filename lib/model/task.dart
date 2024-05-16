const String taskTableName = "tasks";

const String taskIdField = "id";
const String taskTitleField = "title";
const String taskDescriptionField = "description";
const String taskDueDateField = "due_date";
const String taskIsDoneField = "is_done";

const List<String> taskColumns = [
  taskIdField,
  taskTitleField,
  taskDescriptionField,
  taskDueDateField,
  taskIsDoneField,
];

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
        id: json[taskIdField] as int?,
        title: json[taskTitleField] as String,
        description: json[taskDescriptionField] as String?,
        dueDate: DateTime.parse(json[taskDueDateField] as String),
        isDone: json[taskIsDoneField] == 1,
      );

  Map<String, dynamic> toJson() => {
        taskIdField: id,
        taskTitleField: title,
        taskDescriptionField: description,
        taskDueDateField: dueDate.toIso8601String(),
        taskIsDoneField: isDone ? 1 : 0,
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
