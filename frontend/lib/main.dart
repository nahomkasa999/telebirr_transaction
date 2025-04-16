import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "dart:math";

String generateRandomTransactionNumber() {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
    10,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'SMS Listener App', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Telephony telephony = Telephony.instance;
  List<String> transactionNumbers = [];

  Future<void> getTransctionValues() async {
    final url = Uri.parse("http://localhost:3000/transactions");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          transactionNumbers.clear();
          for (var transaction in data) {
            transactionNumbers.add(
              '${transaction['transactionAmount']} birr - ${transaction['transactionId']}',
            );
          }
        });
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load transactions")));
      }
    } else {
      print("Failed to load data: ${response.statusCode}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load transactions")));
    }
  }

  @override
  void initState() {
    super.initState();
    getTransctionValues();
    // Start listening to incoming SMS
    listenForIncomingSms();
  }

  // Function to listen for incoming SMS
  void listenForIncomingSms() async {
    print("listening messages");

    String randomTransction = generateRandomTransactionNumber();

    Map<String, String> message = {
      "address": "+251908302638",
      "body":
          "Dear SISAY You have paid ETB 300.00 for package Monthly Unlimited Premium: Unlimited Internet and SMS purchase made for 929333563 on 24/03/2025 13:39:11. Your transaction number is  ${randomTransction}. Your current balance is ETB 5.04.To download your payment information please click this link: https://transactioninfo.ethiotelecom.et/receipt/${randomTransction} Thank you for using telebirr Ethio telecom",
    };

    // bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    // if (permissionsGranted != null && permissionsGranted) {
    // telephony.listenIncomingSms(
    //onNewMessage: (SmsMessage message) {
    //  if (message.address == "+251908302638") {
    Map<String, String> details = extractTransactionDetails(
      message['body'] ?? '',
    );
    String transactionId = details['transactionId'] ?? '';
    String paidPrice = details['paidPrice'] ?? '';

    if (transactionId.isNotEmpty && paidPrice.isNotEmpty) {
      // Add the transaction to the list
      setState(() {
        transactionNumbers.add('$paidPrice birr - $transactionId');
      });

      // Send the transaction to the backend
      sendTransaction(transactionId, paidPrice);
    }
    //}
    //  },
    //     onBackgroundMessage: backgroundMessageHandler,
    //   );
    // } else {
    //   print("Permissions not granted");
    // }
  }

  // Function to extract transaction number using regex
  String extractTransactionNumber(String message) {
    RegExp regExp = RegExp(r"Transaction number is (\w+)");
    RegExpMatch? match = regExp.firstMatch(message);

    if (match != null) {
      return match.group(0) ?? '';
    }
    return '';
  }
  //0936453956

  Map<String, String> extractTransactionDetails(String message) {
    RegExp urlRegExp = RegExp(r"https?://[^\s]+/(\w+)");
    RegExp priceRegExp = RegExp(r"paid ETB ([\d,]+)");

    RegExpMatch? urlMatch = urlRegExp.firstMatch(message);
    RegExpMatch? priceMatch = priceRegExp.firstMatch(message);

    String transactionId = urlMatch?.group(1) ?? '';
    String paidPrice = priceMatch?.group(1)?.replaceAll(',', '') ?? '';

    return {'transactionId': transactionId, 'paidPrice': paidPrice};
  }

  Future<void> sendTransaction(String transactionId, String paidPrice) async {
    final url = Uri.parse('http://localhost:3000/transactions');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'transactionId': transactionId,
        'paidPrice': paidPrice,
      }),
    );

    if (response.statusCode == 201) {
      print('Transaction sent successfully');
    } else {
      print('Failed to send transaction: ${response.body}');
    }
  }

  // Function to handle background messages
  @pragma('vm:entry-point')
  static void backgroundMessageHandler(SmsMessage message) async {
    // Handle message when the app is in the background
    print("Background SMS: ${message.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SMS Listener')),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: transactionNumbers.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(transactionNumbers[index]));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listenForIncomingSms();
        },
        child: Icon(Icons.message),
        tooltip: 'Start Listening for SMS',
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .endFloat, // You can change this to centerFloat if needed
    );
  }
}
