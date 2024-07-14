import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tracker/views/sub_widgets/ratiobar.dart';
import '../controller/transaction_controller.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';

class MainScreen extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Obx(() => _buildSummaryCard(context)),
          Expanded(
            child: Obx(() => _buildTransactionList()),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final totalExpense = controller.totalExpense.value;
    final totalIncome = controller.totalIncome.value;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.blueGrey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryColumn('Expenses', totalExpense, Colors.red),
                  _buildSummaryColumn('Income', totalIncome, Colors.green),
                  _buildSummaryColumn('Balance', totalIncome - totalExpense, null),
                ],
              ),
              const SizedBox(height: 10),
              _buildRatioBar(totalIncome, totalExpense, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(String title, double value, Color? color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '\$${formatNumber(value)}',
          style: TextStyle(color: color ?? Colors.black),
        ),
      ],
    );
  }

  Widget _buildRatioBar(double totalIncome, double totalExpense, double screenWidth) {
    return Ratiobar(totalIncome: totalIncome, totalExpense: totalExpense, screenWidth: screenWidth,);
  }

  Widget _buildTransactionList() {
    final transactions = controller.transactions;
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions found'),
      );
    }

    List<Widget> transactionWidgets = [];
    DateTime? currentDate;

    List<Widget> currentDayTransactions = [];

    for (var i = 0; i < transactions.length; i++) {
      var transaction = transactions[i];
      final transactionDate = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (currentDate == null || currentDate != transactionDate) {
        if (currentDayTransactions.isNotEmpty) {
          transactionWidgets.add(_buildDateContainer(currentDate!, currentDayTransactions));
          currentDayTransactions = [];
        }
        currentDate = transactionDate;
      }
      currentDayTransactions.add(_buildTransactionTile(transaction, isLast: i == transactions.length - 1 || transactions[i + 1].date.day != transaction.date.day));
    }
    if (currentDayTransactions.isNotEmpty) {
      transactionWidgets.add(_buildDateContainer(currentDate!, currentDayTransactions));
    }

    return ListView(
      children: transactionWidgets,
    );
  }

  Widget _buildDateContainer(DateTime date, List<Widget> transactions) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.cyanAccent.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, style: BorderStyle.solid),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd MMMM yyyy').format(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            Column(children: transactions),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, {bool isLast = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            transaction.description,
            style: const TextStyle(fontWeight: FontWeight.w100),
          ),
          trailing: Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          onTap: () => controller.deleteTransaction(controller.transactions.indexOf(transaction)),
        ),
        if (!isLast) const Divider(
          color: Colors.black,
        ),
      ],
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8.0,
            backgroundColor: Colors.white,
            child: AddTransactionModal(),
          ),
        );
      },
    );
  }

  String formatNumber(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(2);
    }
  }
}

