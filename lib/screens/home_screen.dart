import 'package:expense_tracker/screens/category_details_screen.dart';
import 'package:expense_tracker/widgets/sort_button.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  SortType _sortType = SortType.dateDesc;

  void _addNewExpense(String title, double amount, ExpenseCategory category) {
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      amount: amount,
      date: DateTime.now(),
      category: category,
    );

    setState(() {
      _expenses.add(newExpense);
    });
  }

  void _deleteExpense(int id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Expense deleted')));
  }

  double get _totalExpenses =>
      _expenses.fold(0.0, (sum, item) => sum + item.amount);

  double _getCategoryTotal(ExpenseCategory category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<Expense> _getSortedExpenses() {
    final list = List<Expense>.from(_expenses);

    switch (_sortType) {
      case SortType.dateDesc:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortType.dateAsc:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortType.amountDesc:
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortType.amountAsc:
        list.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return list;
  }

  void _startAddNewExpense() {
    showDialog(
      context: context,
      builder: (ctx) => AddExpenseDialog(onAdd: _addNewExpense),
    );
  }

  void _navigateToCategoryDetails(ExpenseCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CategoryDetailsScreen(category: category, expenses: _expenses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          SortButton(
            currentSort: _sortType,
            onSortChanged: (newSort) => setState(() => _sortType = newSort),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Text(
              'Total: ₴${_totalExpenses.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: ExpenseCategory.values.length,
            itemBuilder: (context, index) {
              final cat = ExpenseCategory.values[index];
              return CategoryCard(
                category: cat,
                totalAmount: _getCategoryTotal(cat),
                onTap: () => _navigateToCategoryDetails(cat),
              );
            },
          ),

          const SizedBox(height: 16),
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: TransactionList(
              expenses: _getSortedExpenses(),
              onDelete: _deleteExpense,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startAddNewExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
