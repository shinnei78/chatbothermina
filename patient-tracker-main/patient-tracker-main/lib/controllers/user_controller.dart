import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/core/models/user_model.dart';
import 'dart:io';

class UserController extends GetxController {
  final _user = Rxn<UserModel>();
  UserModel? get user => _user.value;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      final snapshot = await firestore.collection('users').doc(currentUser.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        _user.value = UserModel.fromMap(snapshot.data()!, currentUser.uid);
      } else {
        _user.value = UserModel(
          uid: currentUser.uid,
          email: currentUser.email ?? '',
          firstName: '',
          lastName: '',
          dob: '',
          gender: '',
          phone: '',
          address: '',
          bloodType: '',
          allergies: [],
          photoUrl: '',
        );
      }
    }
  }

  // Fungsi untuk upload foto profil
  Future<void> uploadProfilePicture(File file) async {
    final currentUser = auth.currentUser;
    if (currentUser == null) return;

    try {
      final fileName = 'profile_pictures/${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = storage.ref().child(fileName);

      // Upload foto ke Firebase Storage
      await storageRef.putFile(file);

      // Dapatkan URL foto setelah upload
      final photoUrl = await storageRef.getDownloadURL();

      // Update URL foto di Firestore
      await updateProfile({'photoUrl': photoUrl});

      Get.snackbar('Success', 'Profile picture updated!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload profile picture');
    }
  }

  // Fungsi untuk update data profil
  Future<void> updateProfile(Map<String, dynamic> updatedFields) async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      try {
        final docRef = firestore.collection('users').doc(currentUser.uid);
        await docRef.set(updatedFields, SetOptions(merge: true));

        // Update data lokal di aplikasi
        _user.value = _user.value?.copyWithFromMap(updatedFields);

        Get.snackbar('Success', 'Profile updated successfully!');
      } catch (e) {
        Get.snackbar('Error', 'Failed to update profile');
      }
    }
  }

  String getInitials() {
    if (user == null) return "";
    return "${user!.firstName.isNotEmpty ? user!.firstName[0] : ''}${user!.lastName.isNotEmpty ? user!.lastName[0] : ''}".toUpperCase();
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed('/login');
  }
}
