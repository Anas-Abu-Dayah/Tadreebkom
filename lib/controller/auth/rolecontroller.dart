import 'package:get/get.dart';
import 'package:tadreebkomapplication/core/constant/routes.dart';

abstract class RoleController extends GetxController {
  role();
  goToStudentSignUP();
  goToSchoolSignUp();
  goTOsignIn();
}

class RoleControllerImp extends RoleController {
  @override
  role() {}
  @override
  goToSchoolSignUp() {
    Get.toNamed(AppRoute.signupcenter);
  }

  @override
  goToStudentSignUP() {
    Get.toNamed(AppRoute.signup);
  }

  @override
  goTOsignIn() {
    Get.offAllNamed(AppRoute.login);
  }
}
