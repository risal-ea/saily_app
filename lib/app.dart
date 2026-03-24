import 'package:flutter/material.dart';
import 'package:saily_app/core/routes/app_routes.dart';
import 'package:saily_app/views/auth/login_screen.dart';
import 'package:saily_app/views/auth/signup_screen.dart';
import 'package:saily_app/views/home/home_screen.dart';
import 'package:saily_app/views/onboarding/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saily',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}
