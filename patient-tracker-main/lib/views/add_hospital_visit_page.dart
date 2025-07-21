import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hospital_visits_controller.dart';
import '../models/hospital_visit-model.dart';

class AddHospitalVisitPage extends StatefulWidget {
  const AddHospitalVisitPage({super.key});

  @override
  State<AddHospitalVisitPage> createState() => _AddHospitalVisitPageState();
}

class _AddHospitalVisitPageState extends State<AddHospitalVisitPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<HospitalVisitController>();

  final visitNumberController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final patientNameController = TextEditingController();
  final doctorNameController = TextEditingController();
  final specializationController = TextEditingController();
  final purposeController = TextEditingController();
  final resultController = TextEditingController();
  final notesController = TextEditingController();
  final visitDateController = TextEditingController();

  String reservation = 'Ya';

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      visitDateController.text = picked.toIso8601String().split('T').first;
    }
  }

  void _saveVisit() async {
    if (_formKey.currentState!.validate()) {
      final visit = HospitalVisit(
        id: '', // akan di-generate Firestore
        visitNumber: visitNumberController.text,
        hospitalName: hospitalNameController.text,
        visitDate: visitDateController.text,
        reservation: reservation,
        patientName: patientNameController.text,
        doctorName: doctorNameController.text,
        specialization: specializationController.text,
        purpose: purposeController.text,
        result: resultController.text,
        notes: notesController.text,
      );

      await controller.addVisit(visit);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Kunjungan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: visitNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'No. Kunjungan'),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: hospitalNameController,
                decoration: const InputDecoration(labelText: 'Nama Rumah Sakit'),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: visitDateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kunjungan',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (val) => val == null || val.isEmpty ? 'Pilih tanggal' : null,
              ),
              DropdownButtonFormField<String>(
                value: reservation,
                items: ['Ya', 'Tidak']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => reservation = val!),
                decoration: const InputDecoration(labelText: 'Reservasi'),
              ),
              TextFormField(
                controller: patientNameController,
                decoration: const InputDecoration(labelText: 'Nama Pasien'),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: doctorNameController,
                decoration: const InputDecoration(labelText: 'Nama Dokter'),
              ),
              TextFormField(
                controller: specializationController,
                decoration: const InputDecoration(labelText: 'Spesialisasi'),
              ),
              TextFormField(
                controller: purposeController,
                decoration: const InputDecoration(labelText: 'Tujuan Kunjungan'),
              ),
              TextFormField(
                controller: resultController,
                decoration: const InputDecoration(labelText: 'Hasil Kunjungan'),
              ),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Catatan'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveVisit,
                child: const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
