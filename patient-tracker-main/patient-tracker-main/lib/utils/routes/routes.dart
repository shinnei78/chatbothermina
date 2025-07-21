import 'package:get/get.dart';
import 'package:patient_tracker/views/doctor_records.dart';
import 'package:patient_tracker/views/help.dart';
import 'package:patient_tracker/views/hospital_visits.dart';
import 'package:patient_tracker/views/recommendations.dart';
import 'package:patient_tracker/views/dashboard.dart';
import 'package:patient_tracker/views/doctors.dart';
import 'package:patient_tracker/views/home.dart';
import 'package:patient_tracker/views/hospitals.dart';
import 'package:patient_tracker/views/login.dart';
import 'package:patient_tracker/views/registration.dart';
import 'package:patient_tracker/views/welcome.dart';
import 'package:patient_tracker/views/onboarding.dart';
import 'package:patient_tracker/views/profile.dart';
import 'package:patient_tracker/views/medical_records.dart';
import 'package:patient_tracker/views/medications.dart';
import 'package:patient_tracker/views/help_support.dart';
import 'package:patient_tracker/views/chatbot_page.dart';
import 'package:patient_tracker/widgets/common/page_wrapper.dart';
import 'package:patient_tracker/views/settings_profile.dart';
import 'package:patient_tracker/views/forgot_password.dart';
import 'package:patient_tracker/views/edit_profile_screen.dart';
import 'package:patient_tracker/views/add_hospital_visit_page.dart';

class Routes {
  static var routes = [
    // Halaman Login dan Registrasi
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/registration', page: () => Registration()),
    GetPage(name: '/forgot-password', page: () => ForgotPasswordPage()),

    // Halaman Home dan Onboarding
    GetPage(name: '/home', page: () => Home()),
    GetPage(name: '/welcome', page: () => WelcomeView()),
    GetPage(name: '/onboarding', page: () => OnboardingView()),

    // Dashboard, Profile, dan Edit Profile
    GetPage(name: '/dashboard', page: () => PageWrapper(child: Dashboard())),
    GetPage(name: '/profile', page: () => PageWrapper(child: ProfileScreen())),
    GetPage(name: '/edit_profile_screen', page: () => EditProfileScreen()),

    // Halaman Medications dan Medical Records
    GetPage(name: '/medication', page: () => PageWrapper(child: MedicationPage())),
    GetPage(name: '/medical_records', page: () => PageWrapper(child: MedicalRecordsPage())),

    // Dokter dan Rumah Sakit
    GetPage(name: '/doctors', page: () => PageWrapper(child: DoctorPage())),
    GetPage(name: '/hospitals', page: () => PageWrapper(child: HospitalPage())),

    // Halaman Recommendations dan Doctor Records
    GetPage(name: '/recommendations', page: () => PageWrapper(child: RecommendationPage())),
    GetPage(name: '/doctor_records', page: () => PageWrapper(child: DoctorRecordsPage())),

    // Halaman Hospital Visits dan Help
    GetPage(name: '/hospital_visits', page: () => PageWrapper(child: HospitalVisitPage())),
    GetPage(name: '/help', page: () => PageWrapper(child: UserGuidePage())),

    // Tambah Kunjungan Rumah Sakit
    GetPage(name: '/add_hospital_visit', page: () => AddHospitalVisitPage()),

    // Help Support dan Settings Profile
    GetPage(name: '/help_support', page: () => HelpSupportPage()),
    GetPage(name: '/settings_profile', page: () => SettingsProfilePage()),

    // Chatbot
    GetPage(name: '/chatbot', page: () => ChatbotPage()),
  ];
}
