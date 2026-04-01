import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: "access");

          if (token != null) {
            options.headers[ApiConstants.authorization] =
                "${ApiConstants.bearer} $token";
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final newToken = await _refreshToken();

            if (newToken != null) {
              error.requestOptions.headers[ApiConstants.authorization] =
                  "${ApiConstants.bearer} $newToken";

              final cloneReq = await _dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // =====================
  // METHODS
  // =====================

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final res = await _dio.get(path, queryParameters: query);
    return res.data;
  }

  Future<dynamic> post(String path, dynamic data) async {
    final res = await _dio.post(path, data: data);
    return res.data;
  }

  Future<dynamic> patch(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    final response = await _dio.patch(path, data: data);
    return response.data;
  }

  Future<dynamic> postFormData(
    String path, {
    required FormData formData,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    final response = await _dio.post(
      path,
      data: formData,
      onSendProgress: onSendProgress,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
    return response.data;
  }

  // =====================
  // REFRESH TOKEN
  // =====================

  Future<String?> _refreshToken() async {
    try {
      final refresh = await _storage.read(key: "refresh");

      final res = await Dio().post(
        "${ApiConstants.baseUrl}${ApiConstants.refreshToken}",
        data: {"refresh": refresh},
      );

      final newAccess = res.data["access"];

      await _storage.write(key: "access", value: newAccess);

      return newAccess;
    } catch (e) {
      await _storage.deleteAll();
      return null;
    }
  }
}
