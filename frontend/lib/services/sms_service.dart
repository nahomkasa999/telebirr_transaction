import 'package:another_telephony/telephony.dart';
import '../utils/random_generator.dart';
import 'local_storage_service.dart';
import 'api_service.dart';
import 'package:frontend/models/transaction.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;
  final ApiService apiService = ApiService();
  final LocalStorageService localStorage = LocalStorageService();

  void listenForSms() async {
    String randomTransaction = generateRandomTransactionNumber();
    Map<String, String> message = {
      "address": "+251908302638",
      "body":
          "Dear SISAY You have paid ETB 300.00 for package Monthly Unlimited Premium: Unlimited Internet and SMS purchase made for 929333563 on 24/03/2025 13:39:11. Your transaction number is ${randomTransaction}.",
    };

    Map<String, String> details = extractTransactionDetails(message['body'] ?? '');
    String transactionId = details['transactionId'] ?? '';
    String paidPrice = details['paidPrice'] ?? '';

    if (transactionId.isNotEmpty && paidPrice.isNotEmpty) {
      Transaction transaction = Transaction(transactionId: transactionId, paidPrice: paidPrice);
      await localStorage.saveTransaction(transaction);
      await apiService.sendTransaction(transaction);
    }
  }

  Map<String, String> extractTransactionDetails(String message) {
    RegExp priceRegExp = RegExp(r"paid ETB ([\d,]+)");
    RegExp urlRegExp = RegExp(r"https?://[^\s]+/(\w+)");

    RegExpMatch? priceMatch = priceRegExp.firstMatch(message);
    RegExpMatch? urlMatch = urlRegExp.firstMatch(message);

    return {
      'transactionId': urlMatch?.group(1) ?? '',
      'paidPrice': priceMatch?.group(1)?.replaceAll(',', '') ?? '',
    };
  }
}
