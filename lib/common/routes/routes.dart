import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:whatsapp_clone/common/models/user_model.dart';
import 'package:whatsapp_clone/feature/auth/pages/login_page.dart';
import 'package:whatsapp_clone/feature/auth/pages/user_info_page.dart';
import 'package:whatsapp_clone/feature/auth/pages/verification_page.dart';
import 'package:whatsapp_clone/feature/chat/pages/chat_page.dart';
import 'package:whatsapp_clone/feature/chat/pages/profile_page.dart';
import 'package:whatsapp_clone/feature/contact/pages/contact_page.dart';
import 'package:whatsapp_clone/feature/home/pages/home_pages.dart';
import 'package:whatsapp_clone/feature/welcome/pages/welcome_page.dart';

class Routes {
  static const String chat = 'chat';
  static const String contact = 'contact';
  static const String home = 'home';
  static const String login = 'login';
  static const String profile = 'profile';
  static const String userInfo = 'user-info';
  static const String verification = 'verification';
  static const String welcome = 'welcome';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case chat:
        final UserModel user = settings.arguments as UserModel;

        return MaterialPageRoute(
          builder: (context) => ChatPage(user: user),
        );
      case contact:
        return MaterialPageRoute(
          builder: (context) => const ContactPage(),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case profile:
        final UserModel user = settings.arguments as UserModel;

        return PageTransition(
          child: ProfilePage(user: user),
          type: PageTransitionType.fade,
          duration: const Duration(
            milliseconds: 800,
          ),
        );
      case userInfo:
        final String? profileImageUrl = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (context) => UserInfoPage(
            profileImageUrl: profileImageUrl,
          ),
        );
      case verification:
        final Map args = settings.arguments as Map;

        return MaterialPageRoute(
          builder: (context) => VerificationPage(
            smsCodeId: args['smsCodeId'],
            phoneNumber: args['phoneNumber'],
          ),
        );
      case welcome:
        return MaterialPageRoute(
          builder: (context) => const WelcomePage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("No Page Route Provided"),
            ),
          ),
        );
    }
  }
}
