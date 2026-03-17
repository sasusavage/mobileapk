import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskItemTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;

  const TaskItemTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(task.title),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete_outline_rounded, color: cs.error),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: task.isDone
              ? cs.surfaceContainerHighest.withValues(alpha: 0.4)
              : cs.surfaceContainerHighest.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: task.isDone
                ? cs.outlineVariant.withValues(alpha: 0.3)
                : cs.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: CheckboxListTile(
          value: task.isDone,
          onChanged: onChanged,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            task.title,
            style: TextStyle(
              decoration:
                  task.isDone ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor: cs.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
              color: task.isDone
                  ? cs.onSurface.withValues(alpha: 0.45)
                  : cs.onSurface,
            ),
          ),
          secondary: task.isDone
              ? Icon(Icons.check_circle_rounded,
                  color: cs.primary.withValues(alpha: 0.7), size: 20)
              : null,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: cs.primary,
        ),
      ),
    );
  }
}
