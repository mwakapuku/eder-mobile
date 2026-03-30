class ApiConstants {
  // =====================
  // BASE URL
  // =====================
  static const bool isDev = true;

  static String get baseUrl => isDev
      ? "http://10.96.139.43:9093/api/v1/"
      : "https://eder.co.tz/api/v1/";

  // =====================
  // AUTH ENDPOINTS
  // =====================
  static String login = "${baseUrl}auth/login/";
  static const String refreshToken = "auth/refresh/";

  // =====================
  // REPORT ENDPOINTS
  // =====================
  static const String createReport = "surveillance/reports/create/";
  static const String myReports = "surveillance/reports/me/";
  static const String behaviors = "surveillance/reports/behaviors/";
  static const String clinicalSigns = "surveillance/reports/clinical-signs/";

  static String reportDetail(int id) => "surveillance/reports/$id/";

  static String uploadImage(int id) => "surveillance/reports/$id/upload-image/";

  // =====================
  // HEADERS
  // =====================
  static const String authorization = "Authorization";
  static const String bearer = "Bearer";
}
