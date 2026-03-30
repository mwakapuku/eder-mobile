import 'package:eder/features/report/models/clinical_sing_model.dart';
import 'package:eder/features/report/service/clinical_sign_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clinicalSignProvider =
    StateNotifierProvider<
      ClinicalSignController,
      AsyncValue<List<ClinicalSignModel>>
    >((ref) => ClinicalSignController());

class ClinicalSignController
    extends StateNotifier<AsyncValue<List<ClinicalSignModel>>> {
  ClinicalSignController() : super(const AsyncLoading()) {
    fetchClinicalSigns();
  }

  final _service = ClinicalSignService();

  Future<void> fetchClinicalSigns() async {
    try {
      state = const AsyncLoading();
      final clinicalSings = await _service.getClinicalSign();
      state = AsyncData(clinicalSings);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
