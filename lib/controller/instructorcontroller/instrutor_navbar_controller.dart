//instructor_navbar_controller.dart
import 'package:get/get.dart';

class InstructorNavBarController extends GetxController {
  static InstructorNavBarController get to => Get.find();

  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  void changeTabIndex(int index) => _currentIndex.value = index;
} 