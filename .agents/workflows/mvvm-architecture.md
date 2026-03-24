---
description: MVVM Architecture Guidelines for Saily App — rules for AI and developers to follow
---

# MVVM Architecture Guidelines — Saily App

> **This file defines the mandatory architecture rules for the `saily_app` Flutter project.**  
> Every AI assistant and developer MUST follow these conventions when reading, modifying, or generating code.

---

## 1. Core Principles

| Layer | Responsibility | Knows About |
|-------|---------------|-------------|
| **Model** | Data structures, serialization, business entities | Nothing else |
| **View** | UI widgets, layout, animations, user input | ViewModel (via Provider/ChangeNotifier) |
| **ViewModel** | State management, business logic, data transformation | Model, Repository/Service |
| **Repository / Service** | Data access (API, local DB, cache) | Model only |

### Golden Rules
1. **Views never contain business logic.** They only call ViewModel methods and listen to ViewModel state.
2. **ViewModels never import Flutter widgets** (`package:flutter/material.dart` is forbidden in ViewModels, except for `ChangeNotifier` from `foundation`).
3. **Models are plain Dart classes** — no Flutter imports, no logic beyond serialization (`fromJson` / `toJson`).
4. **One ViewModel per feature screen.** Shared logic goes into a separate shared ViewModel or a Service.

---

## 2. Folder Structure

All code lives under `lib/`. Follow this exact structure:

```
lib/
├── main.dart                     # App entry point, Provider setup
├── app.dart                      # MaterialApp widget, routes, theme
│
├── core/                         # Shared / cross-cutting concerns
│   ├── constants/                # App-wide constants (colors, strings, API URLs)
│   ├── theme/                    # ThemeData, text styles, color schemes
│   ├── utils/                    # Helper functions, extensions
│   ├── widgets/                  # Reusable widgets shared across features
│   └── routes/                   # Route names & route generator
│
├── data/                         # Data layer
│   ├── models/                   # Plain Dart model classes
│   ├── repositories/             # Repository implementations
│   └── services/                 # API clients, local DB helpers, etc.
│
├── viewmodels/                   # All ViewModels
│   └── <feature>_viewmodel.dart
│
└── views/                        # All View (screen) widgets
    └── <feature>/
        ├── <feature>_screen.dart # Main screen — assembler only (~50–100 lines)
        └── widgets/              # Screen-specific sub-widgets (one concern each)
            ├── <section>_section.dart
            └── <component>_item.dart
```

### Naming Conventions
| Item | Convention | Example |
|------|-----------|---------|
| Model file | `snake_case.dart` | `user_model.dart` |
| Model class | `PascalCase` | `UserModel` |
| ViewModel file | `<feature>_viewmodel.dart` | `home_viewmodel.dart` |
| ViewModel class | `<Feature>ViewModel` | `HomeViewModel` |
| View file | `<feature>_screen.dart` | `home_screen.dart` |
| View class | `<Feature>Screen` | `HomeScreen` |
| Widget section file | `<name>_section.dart` | `for_you_section.dart` |
| Widget item file | `<name>_item.dart` or `<name>_card.dart` | `esim_card_item.dart` |
| Shared widget file | `<name>_widget.dart` | `floating_nav_bar.dart` |
| Repository file | `<entity>_repository.dart` | `user_repository.dart` |
| Service file | `<name>_service.dart` | `api_service.dart` |

---

## 3. State Management — Provider + ChangeNotifier

Use the **`provider`** package as the state management solution.

### ViewModel Template

```dart
// file: lib/viewmodels/home_viewmodel.dart
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  // ---------- State ----------
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ---------- Actions ----------
  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call repository / service
      // _data = await _repository.getData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### View Template

```dart
// file: lib/views/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/viewmodels/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Build UI using viewModel state
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: const Center(child: Text('Hello')),
        );
      },
    );
  }
}
```

### Provider Registration (main.dart)

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        // Add more providers here
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## 4. Model Template

```dart
// file: lib/data/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

---

## 5. Repository Template

```dart
// file: lib/data/repositories/user_repository.dart
import 'package:saily_app/data/models/user_model.dart';
import 'package:saily_app/data/services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  Future<UserModel> getUser(String id) async {
    final json = await _apiService.get('/users/$id');
    return UserModel.fromJson(json);
  }

  Future<List<UserModel>> getAllUsers() async {
    final jsonList = await _apiService.get('/users') as List;
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }
}
```

---

## 6. Rules for AI Code Generation

> **Every AI assistant MUST follow these rules when writing or modifying code in this project.**

### DO ✅
- Place new screens in `lib/views/<feature>/`
- Place new ViewModels in `lib/viewmodels/`
- Place new models in `lib/data/models/`
- Place new repositories/services in `lib/data/repositories/` or `lib/data/services/`
- Use `ChangeNotifier` + `notifyListeners()` for state updates
- Use `Consumer<T>` or `context.watch<T>()` in Views to listen to state
- Use `context.read<T>()` for one-time actions (button presses)
- **Keep the main `*_screen.dart` short (~50–100 lines) — it should only assemble sub-widgets**
- **Extract every distinct UI section into its own file in the feature's `widgets/` folder**
- Each widget file should have ONE clear responsibility (e.g. a card, a section, a nav bar)
- Register all ViewModels as providers in `main.dart`
- Use dependency injection (pass Repository/Service into ViewModel constructors)

### DON'T ❌
- **Never** put `setState()` for business logic — that belongs in the ViewModel
- **Never** call APIs or access databases directly from a View
- **Never** import `material.dart` in a ViewModel (use `foundation.dart` for `ChangeNotifier`)
- **Never** put navigation logic inside a ViewModel — Views handle navigation
- **Never** create god-classes — split large ViewModels by feature
- **Never** store `BuildContext` in a ViewModel
- **Never** let a `*_screen.dart` file exceed ~150 lines — extract sections into `widgets/`

---

## 7. Dependency Packages (Required)

Add these to `pubspec.yaml` when starting feature work:

```yaml
dependencies:
  provider: ^6.1.2        # State management
  http: ^1.2.0             # Networking (if needed)
  shared_preferences: ^2.3.0  # Local storage (if needed)
```

---

## 8. Data Flow Diagram

```
┌─────────┐   user action   ┌─────────────┐   fetch/save   ┌──────────────┐   request   ┌─────────┐
│  VIEW    │ ──────────────► │  VIEWMODEL   │ ─────────────► │  REPOSITORY  │ ──────────► │ SERVICE │
│ (Widget) │                 │ (ChangeNoti) │                │              │             │ (API/DB)│
│          │ ◄────────────── │              │ ◄───────────── │              │ ◄────────── │         │
└─────────┘   state update   └─────────────┘   data (Model)  └──────────────┘   response  └─────────┘
              (notifyListeners)
```

---

## 9. Checklist Before Writing Code

- [ ] Identified which feature/screen this belongs to
- [ ] Model class exists in `lib/data/models/`
- [ ] Repository exists in `lib/data/repositories/` (if data access needed)
- [ ] ViewModel exists in `lib/viewmodels/`
- [ ] ViewModel is registered as a Provider in `main.dart`
- [ ] View uses `Consumer` or `context.watch` to rebuild on state changes
- [ ] No business logic in the View
- [ ] No Flutter widget imports in the ViewModel
