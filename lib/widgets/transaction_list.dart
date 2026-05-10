import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class TransactionList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(int id) onDelete;

  const TransactionList({
    super.key,
    required this.expenses,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text('No transactions yet!'));
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Dismissible(
          key: ValueKey(expense.id),

          direction: DismissDirection.endToStart,

          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: const Icon(Icons.delete, color: Colors.white, size: 30),
          ),

          onDismissed: (direction) {
            onDelete(expense.id);
          },

          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: expense.category.color.withValues(alpha: 0.2),
                child: Icon(
                  expense.category.icon,
                  color: expense.category.color,
                ),
              ),
              title: Text(
                expense.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(expense.formattedDate),
              trailing: Text(
                expense.formattedAmount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
