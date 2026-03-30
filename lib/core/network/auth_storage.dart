import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: "access", value: access);
    await _storage.write(key: "refresh", value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: "access");
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh");
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
