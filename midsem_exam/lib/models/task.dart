import 'dart:convert';

class Task {
  final String title;
  final bool isDone;

  const Task({
    required this.title,
    this.isDone = false,
  });

  Task copyWith({
    String? title,
    bool? isDone,
  }) {
    return Task(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] as String,
      isDone: map['isDone'] as bool? ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
