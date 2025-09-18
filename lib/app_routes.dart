import 'package:bike/screens/auth/login_screen.dart';
import 'package:bike/screens/auth/otp_screen.dart';
import 'package:bike/screens/bike_details_screen.dart';
import 'package:bike/screens/guide_screen.dart';
import 'package:bike/screens/invite_friend_screen.dart';
import 'package:bike/screens/main_screen.dart';
import 'package:bike/screens/profile_screen.dart';
import 'package:bike/screens/map/qr_scan_screen.dart';
import 'package:bike/screens/send_request_screen.dart';
import 'package:bike/screens/settings/settings_screen.dart';
import 'package:bike/screens/spalsh_screen.dart';
import 'package:bike/screens/support_screen.dart';
import 'package:bike/screens/top_up_screen.dart';
import 'package:bike/screens/travel_report_screen.dart';
import 'package:bike/screens/wallet_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/animation.dart';

class AppRoutes {
  static const String home = '/home';
  static const String splash = '/splash';
  static const String guidance = '/guidance';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String travelReports = '/travel_reports';
  static const String inviteFriends = '/invite_friends';
  static const String support = '/support';
  static const String settings = '/settings';
  static const String topUp = '/top_up';
  static const String sendRequest = '/send_request';
  static const String qrScan = '/qr_scan';
  static const String bikeDetailsScreen = '/bike_details_screen';

  static const Duration _dur = Duration(milliseconds: 220);
  static final Curve _curve = Curves.easeOutCubic;

  static List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => MainScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: guidance,
      page: () => const GuideScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: otp,
      page: () => const OtpScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: wallet,
      page: () => const Walletscreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: travelReports,
      page: () => const TravelReportsScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: inviteFriends,
      page: () => const NewsScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: support,
      page: () => const SupportScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: topUp,
      page: () => const TopUpScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: sendRequest,
      page: () => const SendRequestScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: qrScan,
      page: () => const QrScanScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
    GetPage(
      name: bikeDetailsScreen,
      page: () => const BikeDetailsScreen(),
      transition: Transition.cupertino,
      curve: _curve,
      transitionDuration: _dur,
    ),
  ];
}
