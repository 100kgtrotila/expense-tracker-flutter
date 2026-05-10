import 'package:expense_tracker/screens/category_details_screen.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _expenses = [
      Expense(
        id: 1,
        title: 'Lunch',
        amount: 25.00,
        category: ExpenseCategory.food,
        date: DateTime.now(),
      ),
      Expense(
        id: 3,
        title: 'Youtube Premium',
        amount: 30,
        category: ExpenseCategory.other,
        date: DateTime.now(),
      ),
      Expense(
        id: 4,
        title: 'Spotify Premium',
        amount: 5,
        category: ExpenseCategory.other,
        date: DateTime.now(),
      ),
      Expense(
        id: 5,
        title: 'T-shirt',
        amount: 20,
        category: ExpenseCategory.shopping,
        date: DateTime.now(),
      ),
    ];
  }

  double get _totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  double _getCategoryTotal(ExpenseCategory category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              'Total: \$${_totalExpenses.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),

            itemCount: ExpenseCategory.values.length,
            itemBuilder: (context, index) {
              final category = ExpenseCategory.values[index];

              return CategoryCard(
                category: category,
                totalAmount: _getCategoryTotal(category),
                onTap: () => _navigateToCategoryDetails(category),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$',
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButton<ExpenseCategory>(
                    value: _selectedCategory,
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() => _selectedCategory = value!);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _amountController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(onPressed: _addExpense, child: const Text('Add')),
              ],
            );
          },
        );
      },
    );
  }

  void _addExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title and amount')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid amount')));
      return;
    }

    setState(() {
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: DateTime.now(),
      );

      _expenses.add(newExpense);

      _titleController.clear();
      _amountController.clear();
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _navigateToCategoryDetails(ExpenseCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CategoryDetailsScreen(category: category, expenses: _expenses),
      ),
    );
  }

  void _deleteExpense(int id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Expense deleted')));
  }
}
