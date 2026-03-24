import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saily_app/core/constants/app_colors.dart';
import 'package:saily_app/core/routes/app_routes.dart';
import 'package:saily_app/viewmodels/auth_viewmodel.dart';
import 'package:saily_app/views/auth/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.authBackground,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),

                          // Logo
                          Image.asset(
                            'assets/images/logo.png',
                            height: 50,
                          ),
                          const SizedBox(height: 24),

                          // Title
                          const Text(
                            'Welcome to Saily',
                            style: TextStyle(
                              fontFamily: 'Fustat',
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.authTitle,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          const Text(
                            'Your eSIM companion for seamless travel.',
                            style: TextStyle(
                              fontFamily: 'Fustat',
                              fontSize: 14,
                              color: AppColors.authSubtitle,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Email label + field
                          _buildLabel('Email'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Enter your Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),

                          // Password label + field
                          _buildLabel('Password'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Create Password',
                            obscure: viewModel.obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                viewModel.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.authHint,
                                size: 20,
                              ),
                              onPressed: viewModel.togglePasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // TODO: Forgot password flow
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontFamily: 'Fustat',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.authLink,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () async {
                                      await viewModel.login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                      if (context.mounted && viewModel.errorMessage == null) {
                                        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.authPrimary,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'Fustat',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Divider — "Or continue with"
                          Row(
                            children: [
                              Expanded(child: Divider(color: AppColors.authFieldBorder)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    fontFamily: 'Fustat',
                                    fontSize: 13,
                                    color: AppColors.authSubtitle,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: AppColors.authFieldBorder)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Social login buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialLoginButton(
                                label: 'Google',
                                icon: const Text('G', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16),
                              SocialLoginButton(
                                label: 'Apple',
                                icon: const Icon(Icons.apple, size: 28, color: Colors.black),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 16),
                              SocialLoginButton(
                                label: 'Facebook',
                                icon: const Icon(Icons.facebook, size: 28, color: Color(0xFF1877F2)),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontFamily: 'Fustat',
                                  fontSize: 14,
                                  color: AppColors.authSubtitle,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(AppRoutes.signup);
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontFamily: 'Fustat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.authLink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fustat',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.authTitle,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Fustat',
        fontSize: 15,
        color: AppColors.authFieldText,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Fustat',
          fontSize: 15,
          color: AppColors.authHint,
        ),
        filled: true,
        fillColor: AppColors.authFieldBackground,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.authFieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.authFieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.authPrimary, width: 1.5),
        ),
      ),
    );
  }
}
