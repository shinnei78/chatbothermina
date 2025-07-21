import 'package:flutter/material.dart';
import 'package:patient_tracker/models/medical_record.dart';  // Import model MedicalRecord

class MedicalRecordDetailPage extends StatelessWidget {
  final MedicalRecord medicalRecord;

  // Konstruktor untuk menerima data rekam medis
  const MedicalRecordDetailPage({Key? key, required this.medicalRecord}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Rekam Medis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('No Registrasi'),
              subtitle: Text(medicalRecord.noRegistrasi),
            ),
            ListTile(
              title: const Text('Judul'),
              subtitle: Text(medicalRecord.judul),
            ),
            ListTile(
              title: const Text('Nama Dokter'),
              subtitle: Text(medicalRecord.namaDokter),
            ),
            ListTile(
              title: const Text('Spesialisasi'),
              subtitle: Text(medicalRecord.spesialisasi),
            ),
            ListTile(
              title: const Text('Tanggal Periksa'),
              subtitle: Text(medicalRecord.record_date),
            ),
            ListTile(
              title: const Text('Keluhan'),
              subtitle: Text(medicalRecord.keluhan),
            ),
            ListTile(
              title: const Text('Diagnosa Dokter'),
              subtitle: Text(medicalRecord.diagnosaDokter),
            ),
            ListTile(
              title: const Text('Obat'),
              subtitle: Text(medicalRecord.obat),
            ),
            ListTile(
              title: const Text('Notes'),
              subtitle: Text(medicalRecord.notes),
            ),
            ListTile(
              title: const Text('Rumah Sakit'),
              subtitle: Text(medicalRecord.rumahSakit),
            ),
          ],
        ),
      ),
    );
  }
}
