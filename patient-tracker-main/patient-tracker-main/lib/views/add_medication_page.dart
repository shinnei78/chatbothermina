import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/medications_controller.dart';
import '../controllers/medical-record_controller.dart';
import '../models/medications_model.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<MedicationController>();
  final medicalController = Get.find<MedicalRecordsController>();

  final nameController = TextEditingController();
  final dosageController = TextEditingController();
  final freqController = TextEditingController();
  final expiredController = TextEditingController();
  final instrController = TextEditingController();

  String status = 'Active';
  String? selectedNoReg;

  @override
  void initState() {
    super.initState();
    medicalController.fetchMedicalRecords();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        expiredController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Obat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Obx(() => ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'No Registrasi'),
                value: selectedNoReg,
                items: medicalController.medicalRecords.map((record) {
                  return DropdownMenuItem<String>(
                    value: record.noRegistrasi,
                    child: Text(record.noRegistrasi),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedNoReg = value;
                  });
                },
                validator: (value) => value == null ? 'Wajib pilih no registrasi' : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Obat'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: dosageController,
                decoration: const InputDecoration(labelText: 'Dosis (mg)'),
              ),
              TextFormField(
                controller: freqController,
                decoration: const InputDecoration(labelText: 'Frekuensi'),
              ),
              TextFormField(
                controller: expiredController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Expired',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: instrController,
                decoration: const InputDecoration(labelText: 'Instruksi'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                onChanged: (val) => setState(() => status = val!),
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Active', 'Non-Active']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newMed = Medication(
                      noRegistrasi: selectedNoReg!,
                      name: nameController.text,
                      dosage: dosageController.text,
                      frequency: freqController.text,
                      expired: expiredController.text,
                      instructions: instrController.text,
                      status: status,
                    );
                    await controller.addMedication(newMed);
                    Get.back();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
