import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class SuccessSignUpdController {
  goToLoginPage();
}

class SuccessSignUpdControllerImp extends SuccessSignUpdController {
  @override
  goToLoginPage() {
    Get.offAllNamed(AppRoute.login);
  }
}
