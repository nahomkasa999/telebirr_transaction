import 'package:another_telephony/telephony.dart';
import 'package:frontend/utils/random_generator.dart';
import 'local_storage_service.dart';
import 'api_service.dart';
class SmsService {
  final Telephony telephony = Telephony.instance;
  final ApiService apiService = ApiService();
  final LocalStorageService localStorage = LocalStorageService();

  void listenForIncomingSms() async {
      String randomTransction = generateRandomTransactionNumber();

      Map<String, String> message = {
      "address": "+251908302638",
      "body":
          "Dear SISAY You have paid ETB 300.00 for package Monthly Unlimited Premium: Unlimited Internet and SMS purchase made for 929333563 on 24/03/2025 13:39:11. Your transaction number is  ${randomTransction}. Your current balance is ETB 5.04.To download your payment information please click this link: https://transactioninfo.ethiotelecom.et/receipt/${randomTransction} Thank you for using telebirr Ethio telecom",
    };

      Map<String, String> details = extractTransactionDetails(
      message['body'] ?? '',
    );
    
  }

  Map<String, String> extractTransactionDetails(String message) {
    RegExp urlRegExp = RegExp(r"https?://[^\s]+/(\w+)");
    RegExp priceRegExp = RegExp(r"paid ETB ([\d,]+)");

    RegExpMatch? urlMatch = urlRegExp.firstMatch(message);
    RegExpMatch? priceMatch = priceRegExp.firstMatch(message);

    String transactionId = urlMatch?.group(1) ?? '';
    String paidPrice = priceMatch?.group(1)?.replaceAll(',', '') ?? '';

    return {'transactionId': transactionId, 'paidPrice': paidPrice};
  }
}
