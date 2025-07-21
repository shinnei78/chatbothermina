class Medication {
  String? id; // Tambahkan ID dokumen dari Firestore
  final String noRegistrasi;
  final String name;
  final String dosage;
  final String frequency;
  final String expired;
  final String instructions;
  String? status;

  Medication({
    this.id, // Tambahkan ke konstruktor
    required this.noRegistrasi,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.expired,
    required this.instructions,
    this.status,
  });

  // Factory constructor dari Firestore
  factory Medication.fromJson(Map<String, dynamic> json, [String? id]) {
    return Medication(
      id: id,
      noRegistrasi: json['noRegistrasi'],
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      expired: json['expired'],
      instructions: json['instructions'],
      status: json['status'],
    );
  }

  // Untuk menyimpan ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'noRegistrasi': noRegistrasi,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'expired': expired,
      'instructions': instructions,
      'status': status,
    };
  }
}
