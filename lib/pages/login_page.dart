// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:jsonplaceholder_app/common/routes/app_routes.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/logo_widget.dart';
import '../widgets/gradient_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
               // Azure Lane gradient
              Color(0xFF3a7bd5),
              Color(0xFF3a6073),
              // Color(0xFF91EAE4),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    buildLogoWidget(),
                    const SizedBox(height: 24),
                    // Card cho các trường nhập liệu
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Color(0xFF1d3557).withValues(alpha: 0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            buildUsernameField(),
                            const SizedBox(height: 16),
                            buildPasswordField(),
                            const SizedBox(height: 16),
                            buildCodeField(),
                            const SizedBox(height: 24),
                            buildGradientButton(
                              text: '登录',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.processing,
                                );
                              },
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
