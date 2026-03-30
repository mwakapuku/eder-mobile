class BehaviorModel {
  final int id;
  final int? behavior;
  final String name;

  BehaviorModel({required this.id, this.behavior, required this.name});

  factory BehaviorModel.fromJson(Map<String, dynamic> json) {
    return BehaviorModel(
      id: json['id'],
      behavior: json['behavior'],
      name: json['name'],
    );
  }
}
