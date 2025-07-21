import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/medications_model.dart';
import '../controllers/medications_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationDetailPage extends StatefulWidget {
  final Medication medication;
  const MedicationDetailPage({super.key, required this.medication});

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  bool isEditing = false;

  late TextEditingController noController;
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late TextEditingController freqController;
  late TextEditingController expiredController;
  late TextEditingController instrController;
  late String status;

  final controller = Get.find<MedicationController>();

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    noController = TextEditingController(text: med.noRegistrasi);
    nameController = TextEditingController(text: med.name);
    dosageController = TextEditingController(text: med.dosage);
    freqController = TextEditingController(text: med.frequency);
    expiredController = TextEditingController(text: med.expired);
    instrController = TextEditingController(text: med.instructions);
    status = med.status ?? 'Active';
  }

  Future<void> _deleteMedication() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Yakin ingin menghapus obat ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );

    if (confirmed == true) {
      final userId = controller.userId;

      final docs = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .where('name', isEqualTo: widget.medication.name)
          .where('noRegistrasi', isEqualTo: widget.medication.noRegistrasi)
          .get();

      for (var doc in docs.docs) {
        await controller.deleteMedication(doc.id);
      }

      Get.back(); // kembali ke list
    }
  }

  Future<void> _saveChanges() async {
    final updated = Medication(
      id: widget.medication.id, // Gunakan ID dokumen (jika tersedia)
      noRegistrasi: noController.text,
      name: nameController.text,
      dosage: dosageController.text,
      frequency: freqController.text,
      expired: expiredController.text,
      instructions: instrController.text,
      status: status,
    );

    await controller.updateMedication(updated);
    setState(() => isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Obat'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteMedication,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            isEditing
                ? TextFormField(
              controller: noController,
              decoration: const InputDecoration(labelText: 'No Registrasi'),
            )
                : Text('No Registrasi: ${widget.medication.noRegistrasi}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            isEditing
                ? TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Obat'),
            )
                : Text('Nama Obat: ${widget.medication.name}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            isEditing
                ? TextFormField(
              controller: dosageController,
              decoration: const InputDecoration(labelText: 'Dosis'),
            )
                : Text('Dosis: ${widget.medication.dosage}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            isEditing
                ? TextFormField(
              controller: freqController,
              decoration: const InputDecoration(labelText: 'Frekuensi'),
            )
                : Text('Frekuensi: ${widget.medication.frequency}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            isEditing
                ? TextFormField(
              controller: expiredController,
              decoration: const InputDecoration(labelText: 'Tanggal Kedaluwarsa'),
            )
                : Text('Tanggal Kedaluwarsa: ${widget.medication.expired}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            isEditing
                ? TextFormField(
              controller: instrController,
              decoration: const InputDecoration(labelText: 'Instruksi'),
            )
                : Text('Instruksi: ${widget.medication.instructions}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                )),
            const SizedBox(height: 20),

            isEditing
                ? DropdownButtonFormField<String>(
              value: status,
              onChanged: (val) => setState(() => status = val!),
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['Active', 'Non-Active'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            )
                : Chip(
              label: Text(
                widget.medication.status ?? 'Unknown',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.medication.status == 'Active' ? Colors.white : Colors.black,
                ),
              ),
              backgroundColor: widget.medication.status == 'Active' ? Colors.green : Colors.grey,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
