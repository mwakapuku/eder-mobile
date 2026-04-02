import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import '../../index_screen.dart';
import '../models/user_model.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../../../core/network/auth_storage.dart';

final authProvider = StateNotifierProvider<AuthController, UserModel?>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<UserModel?> {
  AuthController() : super(null);

  final _service = AuthService();
  final _storage = AuthStorage();

  bool isLoading = false;

  Future<bool> login(String username, String password) async {
    try {
      isLoading = true;

      final data = await _service.login(username, password);

      // Save tokens
      await _storage.saveTokens(data['access'], data['refresh']);

      // Save user
      state = UserModel.fromJson(data['user']);

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<dynamic> logout(BuildContext context) async {
    try {
      await _service.logout();
    } catch (e) {
      // optional: ignore API failure, still logout locally
    }
    await _storage.clear();
    state = null;

    return LoginScreen();
  }
}
