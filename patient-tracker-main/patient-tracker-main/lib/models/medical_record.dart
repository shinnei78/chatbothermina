class MedicalRecord {
  final String id;
  final String user_id;
  final String record_date;
  final String description;
  final String noRegistrasi;
  final String judul;
  final String namaDokter;
  final String spesialisasi;
  final String keluhan;
  final String diagnosaDokter;
  final String obat;
  final String notes;
  final String rumahSakit;

  MedicalRecord({
    required this.id,
    required this.user_id,
    required this.record_date,
    required this.description,
    required this.noRegistrasi,
    required this.judul,
    required this.namaDokter,
    required this.spesialisasi,
    required this.keluhan,
    required this.diagnosaDokter,
    required this.obat,
    required this.notes,
    required this.rumahSakit,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      record_date: json['record_date'].toString(),
      description: json['description'].toString(),
      noRegistrasi: json['noRegistrasi'].toString(),
      judul: json['judul'].toString(),
      namaDokter: json['namaDokter'].toString(),
      spesialisasi: json['spesialisasi'].toString(),
      keluhan: json['keluhan'].toString(),
      diagnosaDokter: json['diagnosaDokter'].toString(),
      obat: json['obat'].toString(),
      notes: json['notes'].toString(),
      rumahSakit: json['rumahSakit'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': user_id,
      'record_date': record_date,
      'description': description,
      'noRegistrasi': noRegistrasi,
      'judul': judul,
      'namaDokter': namaDokter,
      'spesialisasi': spesialisasi,
      'keluhan': keluhan,
      'diagnosaDokter': diagnosaDokter,
      'obat': obat,
      'notes': notes,
      'rumahSakit': rumahSakit,
    };
  }
}
