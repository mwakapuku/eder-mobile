import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  Future<Map<String, dynamic>> login(String username, String password) async {
    return await _api.post(
      ApiConstants.login,
      {
        "username": username,
        "password": password,
      },
    );
  }
}