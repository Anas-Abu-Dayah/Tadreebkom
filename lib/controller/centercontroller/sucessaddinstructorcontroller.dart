import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tadreebkomapplication/controller/centercontroller/addinstructorpagecontroller.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class SuccessAddInstructorController {
  goToCenterPage();
  sendInstructorEmail(String recipientEmail, String username);
}

class SuccessAddInstructorControllerImp extends SuccessAddInstructorController {
  // ① Grab your AddInstructorPageControllerImp so you can see its queue
  final AddInstructorPageControllerImp addCtrl = Get.find();
  final GetStorage storage = GetStorage();

  @override
  void goToCenterPage() async {
    // ② For each pending instructor, send them the email
    for (final inst in addCtrl.pendingInstructors) {
      final email = inst['email'] as String;
      final username = inst['username'] as String;
      await sendInstructorEmail(email, username);
    }

    // ③ Now that you’ve emailed them, clear the queue
    addCtrl.pendingInstructors.clear();

    // ④ And navigate back to the center’s home
    Get.offAllNamed(AppRoute.centerhomepage);
  }

  @override
  Future<void> sendInstructorEmail(
    String recipientEmail,
    String username,
  ) async {
    const String apiKey =
        "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";
    const String sendGridUrl = "https://api.sendgrid.com/v3/mail/send";

    final emailData = {
      "personalizations": [
        {
          "to": [
            {"email": recipientEmail},
          ],
          "subject": "Welcome to Tadreebkom – Reset Your Password",
        },
      ],
      "from": {"email": "anasabudayeh9@gmail.com", "name": "Tadreebkom App"},
      "content": [
        {
          "type": "text/html",
          "value": """
            <h3>Hello $username,</h3>
            <p>Your instructor account has been created successfully.</p>
            <p>To sign in, please use the "Forgot Password" flow in the app to pick a password.</p>
            <p>Best regards,<br>Tadreebkom Team</p>
          """,
        },
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
    } else {}
  }
}
