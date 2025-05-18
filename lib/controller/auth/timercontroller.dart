import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt resendTimer = 10.obs;
  RxBool canResend = true.obs; // Initially, user can resend

  Timer? _timer;

  void startResendTimer() {
    canResend.value = false; // Disable resend button
    resendTimer.value = 10; // Reset timer to 10 seconds

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--; // Decrease timer
      } else {
        canResend.value = true; // Enable button when timer ends
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
