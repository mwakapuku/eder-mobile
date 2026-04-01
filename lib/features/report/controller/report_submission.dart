import 'dart:ffi';
import 'dart:io';
import 'package:eder/features/report/service/report_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_model.dart';

// Tracks the full submission state across both steps
enum SubmitStep { idle, creatingReport, uploadingImages, done }

class ReportSubmitState {
  final SubmitStep step;
  final double uploadProgress;
  final String? error;
  final int? createdReportId;

  const ReportSubmitState({
    this.step = SubmitStep.idle,
    this.uploadProgress = 0,
    this.error,
    this.createdReportId,
  });

  ReportSubmitState copyWith({
    SubmitStep? step,
    double? uploadProgress,
    String? error,
    int? createdReportId,
  }) => ReportSubmitState(
    step: step ?? this.step,
    uploadProgress: uploadProgress ?? this.uploadProgress,
    error: error,
    createdReportId: createdReportId ?? this.createdReportId,
  );

  bool get isLoading =>
      step == SubmitStep.creatingReport || step == SubmitStep.uploadingImages;
}

class ReportSubmitNotifier extends StateNotifier<ReportSubmitState> {
  final ReportService _service = ReportService();

  ReportSubmitNotifier() : super(const ReportSubmitState());

  // Call this from CreateReportScreen — submits report data only
  Future<int?> submitReport(CreateReportRequest report) async {
    state = state.copyWith(step: SubmitStep.creatingReport, error: null);
    try {
      final created = await _service.createReport(report);
      state = state.copyWith(
        step: SubmitStep.idle,
        createdReportId: created.id,
      );
      return created.id;
    } catch (e) {
      state = state.copyWith(step: SubmitStep.idle, error: e.toString());
      return null;
    }
    return null;
  }

  Future<bool> uploadImages({
    required int reportId,
    required List<File> images,
  }) async {
    state = state.copyWith(step: SubmitStep.uploadingImages, error: null);
    try {
      await _service.uploadReportImages(
        reportId: reportId,
        images: images,
        onProgress: (p) => state = state.copyWith(uploadProgress: p),
      );

      state = state.copyWith(step: SubmitStep.done, uploadProgress: 1.0);
      return true;
    } catch (e) {
      return false;
    }
  }

  void reset() => state = const ReportSubmitState(); // 👈 add this
}

final reportSubmitProvider =
    StateNotifierProvider<ReportSubmitNotifier, ReportSubmitState>(
      (ref) => ReportSubmitNotifier(),
    );
