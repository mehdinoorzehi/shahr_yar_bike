import 'package:bike/screens/auth/login_screen.dart';
import 'package:bike/screens/auth/otp_screen.dart';
import 'package:bike/screens/check_screen.dart';
import 'package:bike/screens/language_selector_screen.dart';
import 'package:bike/screens/others/bike_details_screen.dart';
import 'package:bike/screens/onboarding_screen.dart';
import 'package:bike/screens/others/invite_friend_screen.dart';
import 'package:bike/screens/main_screen.dart';
import 'package:bike/screens/others/profile_screen.dart';
import 'package:bike/screens/map/qr_scan_screen.dart';
import 'package:bike/screens/others/send_request_screen.dart';
import 'package:bike/screens/settings/settings_screen.dart';
import 'package:bike/screens/splash/spalsh_screen.dart';
import 'package:bike/screens/others/support_screen.dart';
import 'package:bike/screens/others/top_up_screen.dart';
import 'package:bike/screens/others/travel_report_screen.dart';
import 'package:bike/screens/others/wallet_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String onBoarding = '/on-boarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String travelReports = '/travel-reports';
  static const String inviteFriends = '/invite-friends';
  static const String support = '/support';
  static const String settings = '/settings';
  static const String topUp = '/top-up';
  static const String sendRequest = '/send-request';
  static const String qrScan = '/qr-scan';
  static const String bikeDetailsScreen = '/bike-details';
  static const String checkScreen = '/check-access';
  static const String languageSelector = '/language-selector';



  static List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onBoarding,
      page: () => const OnBoardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: otp,
      page: () => const OtpScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: wallet,
      page: () => const Walletscreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: travelReports,
      page: () => const TravelReportsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: inviteFriends,
      page: () => const NewsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: support,
      page: () => const SupportScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: topUp,
      page: () => const TopUpScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: sendRequest,
      page: () => const SendRequestScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: qrScan,
      page: () => const QrScanScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bikeDetailsScreen,
      page: () => const BikeDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: checkScreen,
      page: () => const CheckScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: languageSelector,
      page: () => const LanguageSelectorScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
