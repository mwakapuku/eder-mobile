import 'package:eder/features/report/models/clinical_sing_model.dart';
import 'package:eder/features/report/models/behavior_model.dart';
import 'package:eder/features/report/models/report_image_model.dart';

class ReportModel {
  final int id;
  final String title;
  final int mortalityCount;
  final String status;
  final String description;
  final bool assignedToLab;
  final String createdAt;
  final List<ReportImage> images;
  final List<BehaviorModel> behaviors;
  final List<ClinicalSignModel> signs;

  ReportModel({
    required this.id,
    required this.title,
    required this.mortalityCount,
    required this.status,
    required this.description,
    required this.assignedToLab,
    required this.createdAt,
    required this.images,
    required this.behaviors,
    required this.signs,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      mortalityCount: json['mortality_count'],
      title: json['title'],
      status: json['status'],
      description: json['description'],
      assignedToLab: json['assigned_to_lab'],
      createdAt: json['created_at'],
      images: (json['images'] as List)
          .map((e) => ReportImage.fromJson(e))
          .toList(),
      behaviors: (json['behaviors'] as List)
          .map((e) => BehaviorModel.fromJson(e))
          .toList(),
      signs: (json['signs'] as List)
          .map((e) => ClinicalSignModel.fromJson(e))
          .toList(),
    );
  }
}
