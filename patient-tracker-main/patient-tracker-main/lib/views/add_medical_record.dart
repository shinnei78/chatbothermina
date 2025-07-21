import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/controllers/medical-record_controller.dart';
import 'package:patient_tracker/models/medical_record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';  // Import untuk format tanggal

class AddMedicalRecordPage extends StatefulWidget {
  @override
  _AddMedicalRecordPageState createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late String noRegistrasi, judul, namaDokter, spesialisasi, keluhan, diagnosaDokter, obat, notes, rumahSakit;
  late String tanggalPeriksa; // Pastikan ini tidak null
  final medicalController = Get.find<MedicalRecordsController>();  // Mendapatkan controller yang ada
  final TextEditingController _tanggalController = TextEditingController();  // Controller untuk tanggal

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,  // Warna utama DatePicker
            colorScheme: ColorScheme.light(primary: Colors.blue, secondary: Colors.blue),  // Warna aksen
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        tanggalPeriksa = DateFormat('dd/MM/yyyy').format(picked); // Menyimpan tanggal dalam format dd/MM/yyyy
        _tanggalController.text = tanggalPeriksa;  // Mengupdate TextEditingController
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tanggalPeriksa = '';  // Inisialisasi dengan nilai kosong
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Rekam Medis"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Field No Registrasi (Hanya angka)
              TextFormField(
                decoration: InputDecoration(labelText: 'No Registrasi'),
                keyboardType: TextInputType.number, // Pastikan hanya angka
                onSaved: (value) => noRegistrasi = value!,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Harap masukkan nomor registrasi yang valid (hanya angka)';
                  }
                  return null;
                },
              ),
              // Field Judul (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Judul'),
                onSaved: (value) => judul = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan judul yang valid';
                  }
                  return null;
                },
              ),
              // Field Nama Dokter (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Nama Dokter'),
                onSaved: (value) => namaDokter = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama dokter yang valid';
                  }
                  return null;
                },
              ),
              // Field Spesialisasi (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Spesialisasi'),
                onSaved: (value) => spesialisasi = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan spesialisasi yang valid';
                  }
                  return null;
                },
              ),
              // Field Tanggal Periksa (date format)
              TextFormField(
                decoration: InputDecoration(labelText: 'Tanggal Periksa (dd/MM/yyyy)'),
                onTap: () => _selectDate(context),
                readOnly: true, // Membaca saja, tidak bisa diketik
                controller: _tanggalController, // Gunakan controller untuk TextFormField
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan tanggal periksa';
                  }
                  return null;
                },
              ),
              // Field Keluhan (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Keluhan'),
                onSaved: (value) => keluhan = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan keluhan yang valid';
                  }
                  return null;
                },
              ),
              // Field Diagnosa Dokter (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Diagnosa Dokter'),
                onSaved: (value) => diagnosaDokter = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan diagnosa dokter yang valid';
                  }
                  return null;
                },
              ),
              // Field Obat (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Obat'),
                onSaved: (value) => obat = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan obat yang valid';
                  }
                  return null;
                },
              ),
              // Field Notes (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (value) => notes = value!,
              ),
              // Field Rumah Sakit (Harf, angka, simbol)
              TextFormField(
                decoration: InputDecoration(labelText: 'Rumah Sakit'),
                onSaved: (value) => rumahSakit = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama rumah sakit yang valid';
                  }
                  return null;
                },
              ),
              // Tombol Simpan
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Ambil userId dari Firebase Authentication
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId == null) {
                      Get.snackbar("Error", "User is not logged in");
                      return;
                    }

                    // Membuat objek MedicalRecord baru dengan semua parameter yang dibutuhkan
                    final newRecord = MedicalRecord(
                      id: DateTime.now().toString(),  // Generate id unik
                      user_id: userId,  // Gunakan userId dari Firebase Authentication
                      record_date: tanggalPeriksa,
                      description: keluhan,
                      noRegistrasi: noRegistrasi,
                      judul: judul,
                      namaDokter: namaDokter,
                      spesialisasi: spesialisasi,
                      keluhan: keluhan,  // Pastikan keluhan diisi
                      diagnosaDokter: diagnosaDokter,
                      obat: obat,
                      notes: notes,
                      rumahSakit: rumahSakit,
                    );

                    // Menambah rekam medis baru ke controller dan Firestore
                    await medicalController.addMedicalRecord(newRecord);

                    // Menampilkan pesan berhasil
                    Get.snackbar("Success", "Medical record added successfully");

                    Get.back(); // Kembali ke halaman sebelumnya
                  }
                },
                child: const Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
