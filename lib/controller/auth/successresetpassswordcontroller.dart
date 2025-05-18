import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class SuccessResetPasswordController {
  goToLoginPage();
}

class SuccessResetPasswordControllerImp extends SuccessResetPasswordController {
  /// 🔹 Use `RxString` to make it reactive
  var userEmail = "No email provided".obs;

  SuccessResetPasswordControllerImp() {
    /// 🔹 Get the email from arguments and update `RxString`
    var args = Get.arguments;
    if (args != null && args["email"] != null) {
      userEmail.value = args["email"];
    }
  }

  @override
  goToLoginPage() {
    Get.offAllNamed(AppRoute.login);
  }
}
