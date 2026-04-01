import 'package:eder/features/index_screen.dart';
import 'package:eder/features/report/screen/create_report_screen.dart';
import 'package:eder/features/report/screen/upload_images_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/network/auth_check.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: EderApp()));
}

class EderApp extends StatelessWidget {
  const EderApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eder App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const AuthCheck(),
      routes: {
        "/index": (context) => const IndexScreen(),
        "/create-report": (context) => const CreateReportScreen(),
        "/upload-images": (context) => const UploadImagesScreen(),
        "/login": (context) => const LoginScreen(),
      },
    );
  }
}
