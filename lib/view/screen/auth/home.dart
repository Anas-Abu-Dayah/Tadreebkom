import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 70),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Home Page",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(height: 7),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "We sent a one time password to your email. enter 4 digit code that is mentioned in email",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 50),
            OtpTextField(
              focusedBorderColor: Colors.orange,
              enabledBorderColor: Colors.black,
              fieldWidth: 60.0,
              borderRadius: BorderRadius.circular(15),
              numberOfFields: 4,
              borderColor: Colors.brown,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {}, // end onSubmit
            ),
            const SizedBox(height: 30),

            CustomButtonAuth(
              text: "Sign out",
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoute.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
