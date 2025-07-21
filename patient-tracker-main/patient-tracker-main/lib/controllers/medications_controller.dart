import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/medications_model.dart';

class MedicationController extends GetxController {
  var medications = <Medication>[].obs;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  // Ambil semua data obat
  Future<void> fetchMedications() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .get();

      var meds = snapshot.docs.map((doc) {
        return Medication.fromJson(doc.data(), doc.id); // simpan ID dokumen
      }).toList();

      medications.assignAll(meds);
    } catch (e) {
      print('Error fetching medications: $e');
    }
  }

  // Tambahkan obat baru
  Future<void> addMedication(Medication medication) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .add(medication.toJson());

      await fetchMedications(); // refresh list setelah tambah
    } catch (e) {
      print('Error adding medication: $e');
    }
  }

  // Hapus obat berdasarkan ID dokumen
  Future<void> deleteMedication(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .doc(id)
          .delete();

      await fetchMedications(); // refresh list setelah hapus
    } catch (e) {
      print('Error deleting medication: $e');
    }
  }

  // Update obat berdasarkan ID dokumen (bukan cari berdasarkan noRegistrasi)
  Future<void> updateMedication(Medication medication) async {
    try {
      if (medication.id == null) {
        print('Error: Medication ID is null');
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .doc(medication.id!)
          .update(medication.toJson());

      await fetchMedications(); // refresh list setelah update
    } catch (e) {
      print('Error updating medication: $e');
    }
  }

  // Update list secara manual (opsional)
  void updateMedications(List<Medication> list) {
    medications.assignAll(list);
  }

  // Filter obat berdasarkan noRegistrasi (opsional digunakan)
  List<Medication> getByNoReg(String noReg) {
    return medications.where((m) => m.noRegistrasi == noReg).toList();
  }
}
