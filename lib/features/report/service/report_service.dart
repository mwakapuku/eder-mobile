import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/report_model.dart';

class ReportService {
  final ApiClient _api = ApiClient();

  Future<List<ReportModel>> getMyReports() async {
    final response = await _api.get(ApiConstants.myReports);
    final reports = response["data"];

    return (reports as List).map((json) => ReportModel.fromJson(json)).toList();
  }

  /// Step 1: Create the report, returns the new report with its server ID
  Future<ReportModel> createReport(CreateReportRequest report) async {
    final response = await _api.post(
      ApiConstants.createReport,
      report.toJson(),
    );
    print("✅ create report response: $response"); // 👈 add this
    return ReportModel.fromJson(response['data']);
  }

  /// Step 2: Upload images for an existing report ID
  Future<void> uploadReportImages({
    required int reportId,
    required List<File> images,
    void Function(double progress)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'report_id': reportId,
      'images': await Future.wait(
        images.map(
          (file) async => await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      ),
    });

    await _api.postFormData(
      ApiConstants.uploadReportImages,
      formData: formData,
      onSendProgress: onProgress != null
          ? (sent, total) => onProgress(sent / total)
          : null,
    );
  }
}
