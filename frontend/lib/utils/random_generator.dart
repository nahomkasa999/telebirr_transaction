import 'dart:math';

String generateRandomTransactionNumber() {
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();
  return List.generate(
    10,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}
