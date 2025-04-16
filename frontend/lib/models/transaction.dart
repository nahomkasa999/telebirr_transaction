class Transaction {
  final String transactionId;
  final String paidPrice;

  Transaction({
    required this.transactionId,
    required this.paidPrice,
  });

  // You can add a method to convert to/from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      paidPrice: json['paidPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'paidPrice': paidPrice,
    };
  }
}
