class ApiConstants {
  // =====================
  // BASE URL
  // =====================
  static const bool isDev = true;

  static String get baseUrl => isDev
      ? "http://10.35.6.43:9093/api/v1/"
      : "https://eder.co.tz/api/v1/";

  // =====================
  // AUTH ENDPOINTS
  // =====================
  static String login = "${baseUrl}auth/login/";
  static String register = "${baseUrl}auth/register/";
  static String roles = "${baseUrl}auth/roles/";
  static String regions = "${baseUrl}auth/regions/";
  static String districts = "${baseUrl}auth/districts/";
  static String wards = "${baseUrl}auth/wards/";
  static String logout = "${baseUrl}auth/logout/";
  static const String refreshToken = "auth/refresh/";
  static const String profile = "/user/profile/";
  static const String changePassword = "/user/change-password/";

  // =====================
  // REPORT ENDPOINTS
  // =====================
  static const String createReport = "surveillance/reports/create/";
  static const String uploadReportImages = 'surveillance/reports/upload-image/';
  static const String myReports = "surveillance/reports/me/";
  static const String behaviors = "surveillance/reports/behaviors/";
  static const String clinicalSigns = "surveillance/reports/clinical-signs/";

  static String reportDetail(int id) => "surveillance/reports/$id/";

  // =====================
  // HEADERS
  // =====================
  static const String authorization = "Authorization";
  static const String bearer = "Bearer";
}
