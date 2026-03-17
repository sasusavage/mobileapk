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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return TaskItemTile(
                  task: _tasks[index],
                  onChanged: (value) => _toggleTask(index, value),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
