import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_tracker/controllers/user_controller.dart';

class SettingsProfilePage extends StatefulWidget {
  const SettingsProfilePage({super.key});

  @override
  State<SettingsProfilePage> createState() => _SettingsProfilePageState();
}

class _SettingsProfilePageState extends State<SettingsProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController userController = Get.find<UserController>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = true;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          firstNameController.text = data['firstName'] ?? '';
          lastNameController.text = data['lastName'] ?? '';
          usernameController.text = data['username'] ?? '';
          emailController.text = user.email ?? '';
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to load user data');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _saveChanges() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      // Update password jika diisi
      if (passwordController.text.trim().isNotEmpty) {
        await user.updatePassword(passwordController.text.trim());
      }

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        // username & email tidak diubah
      });

      // Update local user data using UserController
      userController.updateProfile({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
      });

      Get.snackbar('Success', 'Profile updated successfully');
      setState(() => isEditMode = false);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to update profile');
    } catch (e) {
      Get.snackbar('Error', 'Unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (!isEditMode && !isLoading)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditMode = true;
                });
              },
            )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildField(
              controller: firstNameController,
              label: 'First Name',
              icon: Icons.person_outline,
              enabled: isEditMode,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              enabled: isEditMode,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: usernameController,
              label: 'Username (not editable)',
              icon: Icons.account_circle_outlined,
              enabled: false,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: emailController,
              label: 'Email (not editable)',
              icon: Icons.email_outlined,
              enabled: false,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: passwordController,
              label: 'New Password (optional)',
              icon: Icons.lock_outline,
              obscure: true,
              enabled: isEditMode,
            ),
            const SizedBox(height: 24),
            isEditMode
                ? ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text("Save Changes"),
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: enabled ? Colors.grey.shade100 : Colors.grey.shade300,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
