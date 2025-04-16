import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class ApiService {
  static final Uri _transactionsUrl = Uri.parse("http://localhost:3000/transactions");

  Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(_transactionsUrl);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<void> sendTransaction(Transaction transaction) async {
    final response = await http.post(
      _transactionsUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send transaction');
    }
  }
}
