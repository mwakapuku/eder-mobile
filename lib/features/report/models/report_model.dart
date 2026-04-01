import 'package:eder/features/report/models/clinical_sing_model.dart';
import 'package:eder/features/report/models/behavior_model.dart';
import 'package:eder/features/report/models/report_image_model.dart';

class ReportModel {
  final int id;
  final String title;
  final int mortalityCount;
  final String? status;
  final String description;
  final bool? assignedToLab;
  final String? createdAt;
  final String category;
  final String level;
  final String? otherSigns;
  final String? otherBehaviors;
  final List<ReportImage>? images;
  final List<BehaviorModel> behaviors;
  final List<ClinicalSignModel> signs;

  ReportModel({
    required this.id,
    required this.title,
    required this.mortalityCount,
    required this.description,
    required this.category,
    required this.level,
    required this.behaviors,
    required this.signs,
    this.status,
    this.assignedToLab,
    this.createdAt,
    this.images,
    this.otherSigns,
    this.otherBehaviors,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    try {
      return ReportModel(
        id: json['id'],
        mortalityCount: json['mortality_count'],
        title: json['title'],
        status: json['status'] as String? ?? '',
        description: json['description'],
        category: json['category'],
        level: json['level'],
        assignedToLab: json['assigned_to_lab'] as bool? ?? false,
        createdAt: json['created_at'] as String? ?? '',
        images:
            (json['images'] as List?)
                ?.map((e) => ReportImage.fromJson(e))
                .toList() ??
            [],
        behaviors:
            (json['behaviors'] as List?)
                ?.map((e) => BehaviorModel.fromJson(e))
                .toList() ??
            [],
        signs:
            (json['signs'] as List?)
                ?.map((e) => ClinicalSignModel.fromJson(e))
                .toList() ??
            [],
      );
    } catch (e) {
      print("❌ ReportModel.fromJson failed: $e");
      print("❌ raw json was: $json");
      rethrow;
    }
  }
}

class CreateReportRequest {
  final String title;
  final String description;
  final String category;
  final String level;
  final int mortalityCount;
  final List<int> clinicalSignIds;
  final List<int> behaviorIds;
  final String? otherSigns;
  final String? otherBehaviors;

  CreateReportRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.mortalityCount,
    required this.clinicalSignIds,
    required this.behaviorIds,
    this.otherSigns,
    this.otherBehaviors,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'category': category,
    'mortality_count': mortalityCount,
    'clinical_signs': clinicalSignIds,
    'behaviors': behaviorIds,
    'latitude': 6.321,
    'longitude': 6.34,
    if (otherSigns != null) 'other_clinical_sign': otherSigns,
    if (otherBehaviors != null) 'other_behavior': otherBehaviors,
  };
}
