// models/supply.dart
class Supply {
  final String id;
  final String title;
  final String description;
  final String sector;
  final String ownerId;
  final List<String> applicants;
  final String? fileUrl;

  Supply({
    required this.id,
    required this.title,
    required this.description,
    required this.sector,
    required this.ownerId,
    required this.applicants,
    this.fileUrl,
  });

  // Firestore'dan gelen veriyi bir Supply nesnesine dönüştürür
  factory Supply.fromMap(Map<String, dynamic> data, String id) {
    return Supply(
      id: id,
      title: data['title'] ?? 'Unknown Title',
      description: data['description'] ?? 'No Description',
      sector: data['sector'] ?? '',
      ownerId: data['ownerId'] ?? '',
      applicants: List<String>.from(data['applicants'] ?? []),
      fileUrl: data['fileUrl'],
    );
  }

  // Supply nesnesini Firestore'a kaydetmek için Map'e dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'sector': sector,
      'ownerId': ownerId,
      'applicants': applicants,
      'fileUrl': fileUrl,
    };
  }
}
