import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  // ── Register ─
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phone,
    required String password,
    required int groupId,
    required int regionId,
    required int districtId,
    required int wardId,
  }) async {
    return await _api.post(ApiConstants.register, {
      "first_name": firstName,
      "last_name": lastName,
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
      "groups": [groupId],
      "region": regionId,
      "district": districtId,
      "ward": wardId,
    });
  }


  Future<Map<String, dynamic>> login(String username, String password) async {
    return await _api.post(ApiConstants.login, {
      "username": username,
      "password": password,
    });
  }

  // ── Roles
  Future<List<Map<String, dynamic>>> fetchRoles(String token) async {
    final res = await _api.get(
      ApiConstants.roles,
    );
    return _extractList(res);
  }

  // ── Regions 
  Future<List<Map<String, dynamic>>> fetchRegions(String token) async {
    final res = await _api.get(
      ApiConstants.regions,
    );
    return _extractList(res);
  }
  Future<Map<String, dynamic>> logout() async {
    final data = {"action": "logout"};
    return await _api.post(ApiConstants.logout, data);
  }

  Future<UserModel> getProfile() async {
    final response = await _api.get(ApiConstants.profile);
    return UserModel.fromJson(response['data']);
  }

  // ── Districts 
  Future<List<Map<String, dynamic>>> fetchDistricts(
      String token, int regionId) async {
    final res = await _api.get(
      "${ApiConstants.districts}?region=$regionId",
    );
    return _extractList(res);
  }

  // ── Wards 
  Future<List<Map<String, dynamic>>> fetchWards(
      String token, int districtId) async {
    final res = await _api.get(
      "${ApiConstants.wards}?district=$districtId",
    );
    return _extractList(res);
  }

  // ── Helper ─
  List<Map<String, dynamic>> _extractList(Map<String, dynamic> res) {
    final data = res['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }
}
