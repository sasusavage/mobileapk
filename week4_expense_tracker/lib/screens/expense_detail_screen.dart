import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/expense_database.dart';
import 'add_expense_screen.dart';
import 'package:intl/intl.dart';
import '../models/category.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late Expense _expense;

  @override
  void initState() {
    super.initState();
    _expense = widget.expense;
  }

  Future<void> _deleteExpense() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ExpenseDatabase.instance.deleteExpense(_expense.id!);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _editExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: _expense),
      ),
    );
    if (result == true) {
      // Refresh the expense data after edit
      final updatedExpense =
          await ExpenseDatabase.instance.getExpense(_expense.id!);
      setState(() {
        _expense = updatedExpense;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final categoryIcon =
        ExpenseCategory.categoryIcons[_expense.category] ?? Icons.category;

    return Scaffold(
      appBar: AppBar(
        title: Text(_expense.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editExpense,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteExpense,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'GHS ${_expense.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(
                      Icons.category,
                      'Category',
                      _expense.category,
                      icon: categoryIcon,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date',
                      dateFormat.format(_expense.date),
                    ),
                    if (_expense.notes != null) ...[
                      const Divider(),
                      _buildDetailRow(
                        Icons.note,
                        'Notes',
                        _expense.notes!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData leadingIcon, String label, String value,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(leadingIcon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: icon != null
                ? Row(
                    children: [
                      Icon(icon, size: 16, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(child: Text(value)),
                    ],
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }
}
