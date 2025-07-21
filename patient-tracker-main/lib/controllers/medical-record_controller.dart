import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medical_record.dart';

class MedicalRecordsController extends GetxController {
  var medicalRecords = <MedicalRecord>[].obs;

  // Tambah rekam medis
  Future<void> addMedicalRecord(MedicalRecord record) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User is not logged in');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medical_records')
          .add(record.toJson());

      await fetchMedicalRecords();
      Get.snackbar("Success", "Medical record added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add medical record: $e");
    }
  }

  // Ambil data rekam medis
  Future<void> fetchMedicalRecords() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User is not logged in');

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medical_records')
          .get();

      final records = snapshot.docs.map((doc) {
        return MedicalRecord.fromJson(doc.data());
      }).toList();

      medicalRecords.assignAll(records);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch medical records: $e");
    }
  }
}
