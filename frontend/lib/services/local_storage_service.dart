import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/models/transaction.dart';

class LocalStorageService {
  Future<List<Transaction>> loadSavedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedTransactions = prefs.getStringList('transactions') ?? [];
    return savedTransactions.map((e) {
      var parts = e.split(' - ');
      return Transaction(transactionId: parts[1], paidPrice: parts[0]);
    }).toList();
  }

  Future<void> saveTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedTransactions = prefs.getStringList('transactions') ?? [];
    savedTransactions.add('${transaction.paidPrice} - ${transaction.transactionId}');
    await prefs.setStringList('transactions', savedTransactions);
  }
}
