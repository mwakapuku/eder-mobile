import 'package:eder/core/constants/api_constants.dart';
import 'package:eder/core/network/api_client.dart';
import 'package:eder/features/report/models/clinical_sing_model.dart';

class ClinicalSignService {
  final ApiClient _api = ApiClient();

  Future<List<ClinicalSignModel>> getClinicalSign() async {
    final response = await _api.get(ApiConstants.clinicalSigns);
    final data = response['data'];

    return (data as List)
        .map((json) => ClinicalSignModel.fromJson(json))
        .toList();
  }
}
