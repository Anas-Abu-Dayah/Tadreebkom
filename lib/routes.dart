import 'package:get/get_navigation/src/routes/get_route.dart';

import 'package:tadreebkomapplication/core/constant/routes.dart';
import 'package:tadreebkomapplication/login_binding.dart';
import 'package:tadreebkomapplication/view/screen/admin/admincenterpage.dart';
import 'package:tadreebkomapplication/view/screen/admin/admininstructorspage.dart';
import 'package:tadreebkomapplication/view/screen/admin/adminpendinginstructors.dart';
import 'package:tadreebkomapplication/view/screen/auth/chooserole.dart';
import 'package:tadreebkomapplication/view/screen/auth/forgetpassword/forgetpassword.dart';
import 'package:tadreebkomapplication/view/screen/auth/forgetpassword/resetpassword.dart';
import 'package:tadreebkomapplication/view/screen/auth/forgetpassword/successresetpassword.dart';
import 'package:tadreebkomapplication/view/screen/auth/forgetpassword/verifycoderesetpassword.dart';
import 'package:tadreebkomapplication/view/screen/auth/home.dart';
import 'package:tadreebkomapplication/view/screen/auth/login.dart';
import 'package:tadreebkomapplication/view/screen/auth/loginverifycode.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupcenter/centerlocation.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupcenter/signupcenter.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupcenter/verifycodecentersignup.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupstudent/signup.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupstudent/studentlocation.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupstudent/successignup.dart';
import 'package:tadreebkomapplication/view/screen/auth/signupstudent/verifycodesignup.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/addinstructorsignup.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/centerhomepage.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/centerprofilepage.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/instructor_profile_page_view.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/scheduale_instructor_view.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/successaddinstructor.dart';
import 'package:tadreebkomapplication/view/screen/centerpage/verifycodecenterpage.dart';
import 'package:tadreebkomapplication/view/screen/instructor/instructor_navbar_view.dart';
import 'package:tadreebkomapplication/view/screen/instructor/iunstructor_profile_page.dart';
import 'package:tadreebkomapplication/view/screen/user/activity_view.dart';
import 'package:tadreebkomapplication/view/screen/user/booking_view.dart';
import 'package:tadreebkomapplication/view/screen/user/centerprofileview.dart';
import 'package:tadreebkomapplication/view/screen/user/checkout_view.dart';
import 'package:tadreebkomapplication/view/screen/user/home_view.dart';
import 'package:tadreebkomapplication/view/screen/user/navbar_view.dart';
import 'package:tadreebkomapplication/view/screen/user/new_card_view.dart';
import 'package:tadreebkomapplication/view/screen/user/profilepageuserview.dart';
import 'package:tadreebkomapplication/view/screen/user/search_view.dart';
import 'package:tadreebkomapplication/view/screen/user/settings_view.dart';
import 'package:tadreebkomapplication/view/screen/user/student_view_instructor_profile.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(name: AppRoute.login, page: () => const Login()),
  GetPage(name: AppRoute.signup, page: () => const SignUp()),
  GetPage(name: AppRoute.role, page: () => const ChooseRole()),
  GetPage(name: AppRoute.signupcenter, page: () => const SignUpCenter()),
  GetPage(name: AppRoute.forgetpassword, page: () => const Forgetpassword()),
  GetPage(name: AppRoute.verifycode, page: () => const VerifyCode()),
  GetPage(name: AppRoute.resetpassword, page: () => const ResetPassword()),
  GetPage(name: AppRoute.successSignup, page: () => const SuccessSignUp()),
  GetPage(
    name: AppRoute.successresetpassword,
    page: () => const SuccessResetPassword(),
  ),
  GetPage(
    name: AppRoute.verifyCodeSignup,
    page: () => const VerifyCodeSignUp(),
    binding: LoginBinding(),
  ),
  GetPage(name: AppRoute.addressstudent, page: () => StudentLocation()),
  GetPage(name: AppRoute.addresscenter, page: () => CenterLocation()),
  GetPage(
    name: AppRoute.verifycodecenter,
    page: () => VerifyCodeCenterSignUp(),
  ),
  GetPage(name: AppRoute.homepage, page: () => HomePage()),
  GetPage(
    name: AppRoute.verifycodelogin,
    page: () => LoginVerifyCode(),
    binding: LoginBinding(),
  ),
  GetPage(name: AppRoute.centerhomepage, page: () => CenterHomePage()),
  GetPage(name: AppRoute.instructorsignup, page: () => Addinstructorsignup()),
  GetPage(
    name: AppRoute.verifycodecenterpage,
    page: () => VerifyCenterCodeSignUp(),
  ),
  GetPage(
    name: AppRoute.instructorsuccesspage,
    page: () => SuccessAddInstructor(),
  ),
  GetPage(name: AppRoute.centerprofilepage, page: () => CenterProfilePage()),
  GetPage(
    name: AppRoute.adminPendingCentersView,
    page: () => AdminPendingCentersView(),
  ),
  GetPage(
    name: AppRoute.adminAllCentersView,
    page: () => AdminAllCentersView(),
  ),
  GetPage(
    name: AppRoute.adminAllInstructorsView,
    page: () => AdminAllInstructorsView(),
  ),
  GetPage(name: AppRoute.navbar, page: () => const CustomBottomNavBar()),
  GetPage(name: AppRoute.home, page: () => const HomeView()),
  GetPage(name: AppRoute.search, page: () => const SearchView()),
  GetPage(name: AppRoute.activity, page: () => const ActivityView()),
  GetPage(name: AppRoute.settings, page: () => const SettingsView()),
  GetPage(name: AppRoute.booking, page: () => const BookingView()),
  GetPage(name: AppRoute.checkout, page: () => const CheckoutView()),
  GetPage(name: AppRoute.newCard, page: () => const NewCardView()),
  GetPage(name: AppRoute.centerProfileView, page: () => CenterProfileView()),
  GetPage(name: AppRoute.userProfilePage, page: () => const UserProfilePage()),
  GetPage(
    name: AppRoute.instructorNavBarView,
    page: () => InstructorNavBarView(),
  ),
  GetPage(
    name: AppRoute.instructorProfilePage,
    page: () => InstructorProfilePage(),
  ),
  GetPage(
    name: AppRoute.instructorProfilePageView,
    page: () => InstructorProfilePageView(),
  ),
  GetPage(
    name: AppRoute.centerSchedulePageView,
    page: () => CenterSchedulePageView(),
  ),

  GetPage(
    name: AppRoute.studentInstructorProfilePageView,
    page: () => StudentInstructorProfilePageView(),
  ),
];
