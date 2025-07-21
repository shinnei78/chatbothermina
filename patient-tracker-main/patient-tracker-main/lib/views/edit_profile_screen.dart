import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patient_tracker/controllers/user_controller.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  late TextEditingController allergiesController;
  late TextEditingController photoUrlController;
  File? _image;

  String gender = '';
  String bloodType = '';

  final genderOptions = ['Male', 'Female'];
  final bloodTypeOptions = ['A', 'B', 'AB', 'O'];

  @override
  void initState() {
    super.initState();
    final user = userController.user!;
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phone);
    dobController = TextEditingController(text: user.dob);
    addressController = TextEditingController(text: user.address);
    allergiesController = TextEditingController(text: user.allergies.join(', '));
    photoUrlController = TextEditingController(text: user.photoUrl);
    gender = user.gender;
    bloodType = user.bloodType;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image == null
                      ? NetworkImage(photoUrlController.text)
                      : FileImage(_image!) as ImageProvider,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: allergiesController,
                decoration: const InputDecoration(labelText: 'Allergies (comma separated)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: gender.isNotEmpty ? gender : null,
                items: genderOptions.map((g) {
                  return DropdownMenuItem(value: g, child: Text(g));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value ?? '';
                  });
                },
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: bloodType.isNotEmpty ? bloodType : null,
                items: bloodTypeOptions.map((b) {
                  return DropdownMenuItem(value: b, child: Text(b));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bloodType = value ?? '';
                  });
                },
                decoration: const InputDecoration(labelText: 'Blood Type'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                onPressed: () async {
                  if (_image != null) {
                    await userController.uploadProfilePicture(_image!);
                  }

                  await userController.updateProfile({
                    'firstName': firstNameController.text,
                    'lastName': lastNameController.text,
                    'phone': phoneController.text,
                    'dob': dobController.text,
                    'address': addressController.text,
                    'allergies': allergiesController.text.split(','),
                    'gender': gender,
                    'bloodType': bloodType,
                  });

                  Get.back();
                  Get.snackbar('Success', 'Profile updated successfully!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
