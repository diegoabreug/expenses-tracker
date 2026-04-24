import 'package:flutter/material.dart';

import 'models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  // data inicial de prueba
  final List<Expense> expenseList = [
    Expense(
      title: 'Cine',
      amount: 5.20,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title:'New York',
      amount: 15.40,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: (){
              //anadir nuevo gasto
            },
            icon: Icon(Icons.add, size: 30,),
          ),
        ],
      ),

      body: ExpenseList(expenses: expenseList),

    );
  }
}

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        final expense = expenses[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${expense.amount.toStringAsFixed(2)}'),
                    SizedBox(width: 10,),
                    Text(expense.formattedDate),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}