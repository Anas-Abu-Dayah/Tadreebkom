import 'dart:convert';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

Future<void> sendOtpWithSendGrid(String recipientEmail, String otp) async {
  const String apiKey =
      "API";
  const String sendGridUrl = "https://api.sendgrid.com/v3/mail/send";

  final Map<String, dynamic> emailData = {
    "personalizations": [
      {
        "to": [
          {"email": recipientEmail},
        ],
        "subject": "Your OTP Code",
      },
    ],
    "from": {"email": "anasabudayeh9@gmail.com", "name": "Tadreebkom App"},
    "content": [
      {"type": "text/plain", "value": "Your OTP verification code is: $otp"},
    ],
  };

  final response = await http.post(
    Uri.parse(sendGridUrl),
    headers: {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    },
    body: jsonEncode(emailData),
  );

  if (response.statusCode == 202) {
    Get.snackbar(
      "OTP:",
      "✅ OTP email sent successfully to $recipientEmail, OTP: $otp",
    );
  } else {
    Get.snackbar("Error:", "❌ Failed to send OTP email: ${response.body}");
  }
}
