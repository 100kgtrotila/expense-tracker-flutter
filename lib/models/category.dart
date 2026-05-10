import 'package:flutter/material.dart';

enum ExpenseCategory { food, transport, shopping, other }

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name => switch (this) {
    ExpenseCategory.food => 'Food',
    ExpenseCategory.transport => 'Transport',
    ExpenseCategory.shopping => 'Shopping',
    ExpenseCategory.other => 'Other',
  };

  IconData get icon => switch (this) {
    ExpenseCategory.food => Icons.restaurant,
    ExpenseCategory.transport => Icons.directions_car,
    ExpenseCategory.shopping => Icons.shopping_bag,
    ExpenseCategory.other => Icons.category,
  };

  Color get color => switch (this) {
    ExpenseCategory.food => Colors.orange,
    ExpenseCategory.transport => Colors.blue,
    ExpenseCategory.shopping => Colors.purple,
    ExpenseCategory.other => Colors.grey,
  };
}
