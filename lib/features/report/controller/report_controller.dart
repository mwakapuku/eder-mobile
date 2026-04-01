import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';
import '../service/report_service.dart';

final reportProvider =
    StateNotifierProvider<ReportController, AsyncValue<List<ReportModel>>>(
      (ref) => ReportController(),
    );

class ReportController extends StateNotifier<AsyncValue<List<ReportModel>>> {
  ReportController() : super(const AsyncLoading()) {
    fetchReports();
  }

  final _service = ReportService();

  Future<void> fetchReports() async {
    try {
      state = const AsyncLoading();
      final reports = await _service.getMyReports();
      state = AsyncData(reports);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
