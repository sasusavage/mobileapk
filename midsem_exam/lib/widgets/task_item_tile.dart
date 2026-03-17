import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItemTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskItemTile({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: onChanged,
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
            fontWeight: FontWeight.w500,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
