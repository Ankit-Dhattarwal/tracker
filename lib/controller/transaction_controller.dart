import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../models/transaction_model.dart';

class TransactionController extends GetxController {
  final box = GetStorage('transactions');
  var transactions = <Transaction>[].obs;
  var totalExpense = 0.0.obs;
  var totalIncome = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();

  }

  void addTransaction(String type, String description, double amount, DateTime date) {
    final transaction = Transaction(
      type: type,
      description: description,
      amount: amount,
      date: date,
    );
    transactions.add(transaction);

    if (type == 'Expense') {
      totalExpense.value += amount;
    } else if (type == 'Income') {
      totalIncome.value += amount;
    }

    saveTransactions();
  }

  void deleteTransaction(int index) {
    final transaction = transactions[index];
    if (transaction.type == 'Expense') {
      totalExpense.value -= transaction.amount;
    } else if (transaction.type == 'Income') {
      totalIncome.value -= transaction.amount;
    }
    transactions.removeAt(index);

    saveTransactions();
  }

  void saveTransactions() {
    box.write('transactions', jsonEncode(transactions.map((transaction) => transaction.toJson()).toList()));
  }

  void loadTransactions() {
    var transactionsJson = box.read('transactions');
    if (transactionsJson != null) {
      Iterable decoded = jsonDecode(transactionsJson);
      transactions.assignAll(decoded.map((json) => Transaction.fromJson(json)));

      // Recalculate totals
      totalExpense.value = 0.0;
      totalIncome.value = 0.0;
      for (var transaction in transactions) {
        if (transaction.type == 'Expense') {
          totalExpense.value += transaction.amount;
        } else if (transaction.type == 'Income') {
          totalIncome.value += transaction.amount;
        }
      }
    }
  }


}
