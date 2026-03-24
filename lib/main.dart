import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saily_app/app.dart';
import 'package:saily_app/core/routes/app_routes.dart';
import 'package:saily_app/data/services/storage_service.dart';
import 'package:saily_app/viewmodels/auth_viewmodel.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';
import 'package:saily_app/viewmodels/onboarding_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  // Uncomment the line below to reset onboarding:
  // await storageService.clearAll();

  // Decide initial route based on onboarding status
  final initialRoute = storageService.hasSeenOnboarding()
      ? AppRoutes.home
      : AppRoutes.onboarding;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}
