import 'package:get/get.dart';
import 'package:tadreebkomapplication/controller/auth/logincontroller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginControllerImplement>(() => LoginControllerImplement());
  }
}
