// lib/main.dart
import 'package:flutter/material.dart';
import 'package:jsonplaceholder_app/pages/qr_scan_page.dart';
import 'pages/login_page.dart';
import 'pages/processing_page.dart';
import 'common/routes/app_routes.dart';
import 'common/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tối ưu hóa bộ nhớ đệm hình ảnh
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Well',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Poppins', // Sử dụng font Poppins
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          bodyLarge: TextStyle(color: AppColors.textPrimary, fontFamily: 'Poppins'),
          bodyMedium: TextStyle(color: AppColors.textSecondary, fontFamily: 'Poppins'),
        ),
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.processing: (context) => const ProcessingPage(),
        AppRoutes.scan: (context) => const QRScanPage()
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}