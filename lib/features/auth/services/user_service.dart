import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';

class UserService {
  final ApiClient _api = ApiClient();

  Future<UserModel> getProfile() async {
    final response = await _api.get(ApiConstants.profile);
    print('✅ profile response: $response');
    return UserModel.fromJson(response['data']);
  }

  Future<UserModel> updateProfile(UserModel user) async {
    final response = await _api.patch(
      ApiConstants.profile,
      data: user.toJson(),
    );
    return UserModel.fromJson(response['data']);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _api.patch(
      ApiConstants.changePassword,
      data: {
        'old_password': oldPassword,
        'password': newPassword,
      },
    );
  }
}