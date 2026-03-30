class ClinicalSignModel {
  final int id;
  final int? sign;
  final String name;

  ClinicalSignModel({required this.id, this.sign, required this.name});

  factory ClinicalSignModel.fromJson(Map<String, dynamic> json) {
    return ClinicalSignModel(
      id: json['id'],
      sign: json['sign'],
      name: json['name'],
    );
  }
}
