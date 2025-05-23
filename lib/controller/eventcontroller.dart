import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EventController extends GetxController {
  final RxBool shouldRefreshInstructors = false.obs;

  void triggerInstructorRefresh() {
    shouldRefreshInstructors.value = true;
  }
}
