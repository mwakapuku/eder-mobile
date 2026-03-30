import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/report_model.dart';

class ReportService {
  final ApiClient _api = ApiClient();

  Future<List<ReportModel>> getMyReports() async {
    final response = await _api.get(ApiConstants.myReports);
    final reports = response["data"];
    
    return (reports as List)
        .map((json) => ReportModel.fromJson(json))
        .toList();
  }
}