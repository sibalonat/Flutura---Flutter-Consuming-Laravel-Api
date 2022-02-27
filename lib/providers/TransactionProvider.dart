import 'package:flutter/material.dart';
import 'package:flutura/models/Transaction.dart';
import 'package:flutura/providers/AuthProvider.dart';
import 'package:flutura/services/api.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> transactions = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  TransactionProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiService = ApiService(authProvider.token);
    init();
  }

  Future init() async {
    transactions = await apiService.fetchTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(String description, String amount, String category, String date) async {
    try {
      Transaction addedTransaction = await apiService.addTransaction(description, amount, category, date);
      transactions.add(addedTransaction);

      notifyListeners();
    } catch (Exception) {
      await authProvider.logout();
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      Transaction updatedTransaction = await apiService.updateTransaction(transaction);
      int index = transactions.indexOf(transaction);

      transactions[index] = updatedTransaction;
      notifyListeners();
    } catch (Exception) {
      await authProvider.logout();
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await apiService.deleteTransaction(transaction.id);
      transactions.remove(transaction);
      notifyListeners();
    } catch (Exception) {
      await authProvider.logout();
    }
  }
}
