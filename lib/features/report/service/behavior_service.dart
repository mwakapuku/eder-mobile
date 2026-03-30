import 'package:eder/core/constants/api_constants.dart';
import 'package:eder/core/network/api_client.dart';
import 'package:eder/features/report/models/behavior_model.dart';
import 'package:eder/features/report/models/clinical_sing_model.dart';

class BehaviorService {
  final ApiClient _api = ApiClient();

  Future<List<BehaviorModel>> getBehavior() async {
    final response = await _api.get(ApiConstants.behaviors);
    final data = response['data'];

    return (data as List)
        .map((json) => BehaviorModel.fromJson(json))
        .toList();
  }
}
