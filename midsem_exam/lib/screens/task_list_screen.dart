import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../widgets/task_item_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static const String _tasksStorageKey = 'student_tasks';
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_tasksStorageKey);

    setState(() {
      if (stored != null && stored.isNotEmpty) {
        _tasks
          ..clear()
          ..addAll(stored.map(Task.fromJson));
      } else {
        _tasks
          ..clear()
          ..addAll(const [
            Task(title: 'Read chapter 3 notes'),
            Task(title: 'Submit Flutter assignment'),
            Task(title: 'Prepare for midsem practical'),
          ]);
      }
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _tasks.map((task) => task.toJson()).toList();
    await prefs.setStringList(_tasksStorageKey, serialized);
  }

  Future<void> _showAddTaskDialog() async {
    final controller = TextEditingController();

    final title = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (title == null || title.isEmpty) return;

    setState(() {
      _tasks.add(Task(title: title));
    });
    await _saveTasks();
  }

  Future<void> _toggleTask(int index, bool? value) async {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(isDone: value ?? false);
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(int index) async {
    setState(() => _tasks.removeAt(index));
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final done = _tasks.where((t) => t.isDone).length;
    final total = _tasks.length;
    final progress = total == 0 ? 0.0 : done / total;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('My Tasks'),
      ),
      body: Column(
        children: [
          // ── Progress header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$done of $total completed',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.65),
                          ),
                    ),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: cs.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: cs.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(cs.primary),
                  ),
                ),
              ],
            ),
          ),
          // ── Task list ────────────────────────────────────────────
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checklist_rounded,
                            size: 64,
                            color: cs.onSurface.withValues(alpha: 0.25)),
                        const SizedBox(height: 12),
                        Text(
                          'No tasks yet.',
                          style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.4)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap + to add one.',
                          style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.3),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItemTile(
                        task: _tasks[index],
                        onChanged: (value) => _toggleTask(index, value),
                        onDelete: () => _deleteTask(index),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
