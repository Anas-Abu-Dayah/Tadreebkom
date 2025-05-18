import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/resetpasswordcontroller.dart';
import 'package:tadreebkomapplication/core/constant/color.dart';
import 'package:tadreebkomapplication/core/functions/validateinput.dart';
import 'package:tadreebkomapplication/view/widget/auth/custombuttomauth.dart';
import 'package:tadreebkomapplication/view/widget/auth/customtextformauth.dart';


class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ResetPasswordControllerImp());
    return Scaffold(
      backgroundColor: AppColor.pagePrimaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.pagePrimaryColor,
        elevation: 0.0,
      ),
      body: GetBuilder<ResetPasswordControllerImp>(
        builder:
            (controller) => Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 70),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Set a new password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "create a new password. Ensure it differs from previous ones for security.",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextFormAuth(
                    isNumber: false,
                    hinttext: "Enter New Password",
                    labeltext: "password",
                    icondata: Icons.lock_outline,
                    mycontroller: controller.password,
                    valid: (val) {
                      return validateInput(val!, 8, 50, "password");
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormAuth(
                    isNumber: false,
                    hinttext: "Re-enter New Password",
                    labeltext: "Confirm password",
                    icondata: Icons.lock_outline,
                    mycontroller: controller.confirmPassword,
                    valid: (val) {
                      return validateInput(val!, 8, 50, "password");
                    },
                  ),

                  CustomButtonAuth(
                    text: "Reset Password",
                    onPressed: () {
                      controller.resetPassword();
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
      ),
    );
  }
}
