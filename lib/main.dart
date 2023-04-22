import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/routes/routes.dart';
import 'package:whatsapp_clone/common/theme/dark_theme.dart';
import 'package:whatsapp_clone/common/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatsapp_clone/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/feature/home/pages/home_pages.dart';
import 'package:whatsapp_clone/feature/welcome/pages/welcome_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // ? These keeps the splash screen on until it loaded up all neccessary data
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Clone',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      onGenerateRoute: Routes.onGenerateRoute,
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          // ? Remove splash screen whenn datas are loaded
          FlutterNativeSplash.remove();

          if (user == null) return const WelcomePage();
          return const HomePage();
        },
        error: (error, trace) {
          return const Scaffold(
              body: Center(
            child: Text(
              "Something wrong happened!",
            ),
          ));
        },
        loading: () {
          return const SizedBox();
          // return const Scaffold(
          //   body: Center(
          //     child: Icon(
          //       Icons.whatsapp,
          //       size: 30,
          //     ),
          //   ),
          // );
        },
      ),
      // home: const WelcomePage(),
      // home: const UserInfoPage(),
      // home: const VerificationPage(),
      // home: const LoginPage(),
      // home: const ContactPage(),
    );
  }
}
