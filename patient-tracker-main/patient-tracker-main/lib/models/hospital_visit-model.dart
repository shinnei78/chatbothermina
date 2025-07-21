class HospitalVisit {
  final String id;
  final String visitNumber;
  final String hospitalName;
  final String visitDate;
  final String reservation;
  final String patientName;
  final String doctorName;
  final String specialization;
  final String purpose;
  final String result;
  final String notes;

  HospitalVisit({
    required this.id,
    required this.visitNumber,
    required this.hospitalName,
    required this.visitDate,
    required this.reservation,
    required this.patientName,
    required this.doctorName,
    required this.specialization,
    required this.purpose,
    required this.result,
    required this.notes,
  });

  factory HospitalVisit.fromJson(String id, Map<String, dynamic> json) {
    return HospitalVisit(
      id: id,
      visitNumber: json['visitNumber'] ?? '',
      hospitalName: json['hospitalName'] ?? '',
      visitDate: json['visitDate'] ?? '',
      reservation: json['reservation'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'] ?? '',
      purpose: json['purpose'] ?? '',
      result: json['result'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitNumber': visitNumber,
      'hospitalName': hospitalName,
      'visitDate': visitDate,
      'reservation': reservation,
      'patientName': patientName,
      'doctorName': doctorName,
      'specialization': specialization,
      'purpose': purpose,
      'result': result,
      'notes': notes,
    };
  }
}
