import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final ExpenseCategory category;
  final List<Expense> expenses;

  const CategoryDetailsScreen({
    super.key,
    required this.category,
    required this.expenses,
  });

  List<Expense> get _categoryExpenses {
    return expenses.where((e) => e.category == category).toList();
  }

  double get _total {
    return _categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color.withValues(alpha: 0.1),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: category.color.withValues(alpha: 0.1),
            child: Column(
              children: [
                Icon(category.icon, size: 48),
                Text(
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('${_categoryExpenses.length} transactions'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              itemCount: _categoryExpenses.length,
              itemBuilder: (context, index) {
                final expense = _categoryExpenses[index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text(expense.formattedDate),
                  trailing: Text(expense.formattedAmount),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
