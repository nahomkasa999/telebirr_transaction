import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<String> transactionNumbers;

  TransactionList({required this.transactionNumbers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactionNumbers.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(transactionNumbers[index]));
      },
    );
  }
}
