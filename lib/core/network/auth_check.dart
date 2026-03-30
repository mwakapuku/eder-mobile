import 'package:eder/features/index_screen.dart';
import 'package:flutter/material.dart';

import '../../features/auth/screens/login_screen.dart';
import 'auth_storage.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> isLoggedIn() async {
    final token = await AuthStorage().getAccessToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final loggedIn = snapshot.data!;

        if (loggedIn) {
          return const IndexScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
