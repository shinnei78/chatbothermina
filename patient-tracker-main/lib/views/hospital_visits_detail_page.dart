import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hospital_visits_controller.dart';
import '../models/hospital_visit-model.dart';

class HospitalVisitDetailPage extends StatefulWidget {
  final HospitalVisit visit;
  const HospitalVisitDetailPage({super.key, required this.visit});

  @override
  State<HospitalVisitDetailPage> createState() => _HospitalVisitDetailPageState();
}

class _HospitalVisitDetailPageState extends State<HospitalVisitDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<HospitalVisitController>();

  late TextEditingController visitNumberController;
  late TextEditingController hospitalNameController;
  late TextEditingController visitDateController;
  late TextEditingController patientNameController;
  late TextEditingController doctorNameController;
  late TextEditingController specializationController;
  late TextEditingController purposeController;
  late TextEditingController resultController;
  late TextEditingController notesController;

  String reservation = 'Ya';

  @override
  void initState() {
    super.initState();
    visitNumberController = TextEditingController(text: widget.visit.visitNumber);
    hospitalNameController = TextEditingController(text: widget.visit.hospitalName);
    visitDateController = TextEditingController(text: widget.visit.visitDate);
    patientNameController = TextEditingController(text: widget.visit.patientName);
    doctorNameController = TextEditingController(text: widget.visit.doctorName);
    specializationController = TextEditingController(text: widget.visit.specialization);
    purposeController = TextEditingController(text: widget.visit.purpose);
    resultController = TextEditingController(text: widget.visit.result);
    notesController = TextEditingController(text: widget.visit.notes);
    reservation = widget.visit.reservation;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(visitDateController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      visitDateController.text = picked.toIso8601String().split('T').first;
    }
  }

  void _updateVisit() async {
    if (_formKey.currentState!.validate()) {
      final updatedVisit = HospitalVisit(
        id: widget.visit.id,
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

      await controller.updateVisit(widget.visit.id, updatedVisit);
      Get.back(); // Kembali setelah update
    }
  }

  void _deleteVisit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus kunjungan ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteVisit(widget.visit.id);
      Get.back(); // keluar setelah hapus
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kunjungan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteVisit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: visitNumberController,
                decoration: const InputDecoration(labelText: 'No. Kunjungan'),
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: hospitalNameController,
                decoration: const InputDecoration(labelText: 'Nama Rumah Sakit'),
              ),
              TextFormField(
                controller: visitDateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Kunjungan',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
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
                onPressed: _updateVisit,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
