import 'package:expense_tracker/models/category.dart';

class Expense {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get formattedAmount => '₴${amount.toStringAsFixed(2)}';
}
