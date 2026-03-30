class ReportImage {
  final int id;
  final String image;

  ReportImage({required this.id, required this.image});

  factory ReportImage.fromJson(Map<String, dynamic> json) {
    return ReportImage(id: json['id'], image: json['image']);
  }
}
