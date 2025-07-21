import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/hospital_visit-model.dart';

class HospitalVisitController extends GetxController {
  var hospitalVisits = <HospitalVisit>[].obs;

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> fetchVisits() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('hospital_visits')
          .get();

      final visits = snapshot.docs
          .map((doc) => HospitalVisit.fromJson(doc.id, doc.data()))
          .toList();

      hospitalVisits.assignAll(visits);
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data kunjungan: $e");
    }
  }

  Future<void> addVisit(HospitalVisit visit) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('hospital_visits')
          .add(visit.toJson());

      await fetchVisits();
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan kunjungan: $e");
    }
  }

  Future<void> updateVisit(String id, HospitalVisit visit) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('hospital_visits')
          .doc(id)
          .update(visit.toJson());

      await fetchVisits();
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui kunjungan: $e");
    }
  }

  Future<void> deleteVisit(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('hospital_visits')
          .doc(id)
          .delete();

      await fetchVisits();
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus kunjungan: $e");
    }
  }
}
