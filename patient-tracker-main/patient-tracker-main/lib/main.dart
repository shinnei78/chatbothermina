import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patient_tracker/core/controllers/main_controller.dart';
import 'package:patient_tracker/controllers/user_controller.dart';
import 'package:patient_tracker/controllers/medical-record_controller.dart'; // Tambahkan import controller medical record
import 'package:patient_tracker/controllers/medications_controller.dart'; // Import MedicationController
import 'package:patient_tracker/core/theme/app_theme.dart';
import 'package:patient_tracker/utils/routes/routes.dart';
import 'firebase_options.dart'; // Mengimpor Firebase options yang sudah di-generate
import 'package:patient_tracker/controllers/hospital_visits_controller.dart';


// Fungsi utama untuk inisialisasi Firebase dan controller
Future<void> main() async {
  // Memastikan inisialisasi sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dengan opsi yang sesuai untuk platform yang digunakan
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Menggunakan FirebaseOptions sesuai platform
  );

  // Menambahkan controller yang dibutuhkan di GetX
  Get.put(MainController(), permanent: true); // MainController sebagai controller utama
  Get.put(UserController(), permanent: true); // UserController untuk user management
  Get.put(MedicalRecordsController(), permanent: true); // Pastikan MedicalRecordsController sudah didaftarkan
  Get.put(MedicationController(), permanent: true); // Pastikan MedicationController sudah didaftarkan
  Get.put(HospitalVisitController(), permanent: true); // ✅ Tambahkan ini

  // Menjalankan aplikasi setelah inisialisasi
  runApp(const AfyaYanguApp());
}

class AfyaYanguApp extends StatelessWidget {
  const AfyaYanguApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rumah Sakit Hermina', // Nama aplikasi
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug di aplikasi
      theme: AppTheme.lightTheme, // Tema terang
      darkTheme: AppTheme.darkTheme, // Tema gelap
      themeMode: ThemeMode.system, // Menyesuaikan tema dengan pengaturan sistem
      initialRoute: "/welcome", // Route awal saat aplikasi dimulai
      getPages: Routes.routes, // Mendefinisikan rute-rute aplikasi
    );
  }
}
