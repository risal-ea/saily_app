import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/app.dart';
import 'package:saily_app/core/routes/app_routes.dart';
import 'package:saily_app/data/services/storage_service.dart';
import 'package:saily_app/viewmodels/onboarding_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Onboarding screen shows first page', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => OnboardingViewModel(storageService),
        child: const MyApp(initialRoute: AppRoutes.onboarding),
      ),
    );

    // Verify the first onboarding page is shown
    expect(find.text('Welcome to Saily'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
