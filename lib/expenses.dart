import 'package:flutter/material.dart';
import 'models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> expenseList = [
    Expense(
      title: 'Cine',
      amount: 5.20,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'New York',
      amount: 15.40,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  // Iconos por categoria
  final Map<Category, IconData> categoryIcons = {
    Category.food: Icons.restaurant,
    Category.travel: Icons.flight,
    Category.leisure: Icons.movie,
    Category.study: Icons.school,
  };

  void _addExpense(Expense expense) {
    setState(() {
      expenseList.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final index = expenseList.indexOf(expense);
    setState(() {
      expenseList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} removed'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              expenseList.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AddExpenseModal(onAddExpense: _addExpense),
    );
  }

  double get _totalAmount =>
      expenseList.fold(0, (sum, e) => sum + e.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseModal,
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          // Total banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('Total Expenses',
                    style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  '\$${_totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Lista de gastos
          Expanded(
            child: expenseList.isEmpty
                ? const Center(child: Text('No expenses yet. Add one!'))
                : ExpenseList(
              expenses: expenseList,
              categoryIcons: categoryIcons,
              onRemove: _removeExpense,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Lista con swipe para eliminar
// ─────────────────────────────────────────────
class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.categoryIcons,
    required this.onRemove,
  });

  final List<Expense> expenses;
  final Map<Category, IconData> categoryIcons;
  final void Function(Expense) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Dismissible(
          key: ValueKey(expense.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.redAccent,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => onRemove(expense),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                children: [
                  Icon(categoryIcons[expense.category],
                      size: 28,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expense.title,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(expense.formattedDate,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Modal para agregar gasto
// ─────────────────────────────────────────────
class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (_titleController.text.trim().isEmpty ||
        amount == null ||
        amount <= 0 ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please enter a valid title, amount and date.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text.trim(),
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Add New Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Titulo
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Monto
          TextField(
            controller: _amountController,
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount (\$)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Fecha y categoria en fila
          Row(
            children: [
              // Date picker
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _selectedDate == null
                        ? 'Pick Date'
                        : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Categoria dropdown
              Expanded(
                child: DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: Category.values
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.name),
                  ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedCategory = val);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}