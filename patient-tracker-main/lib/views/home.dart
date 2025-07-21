import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/views/dashboard.dart';
import 'package:patient_tracker/views/doctors.dart';
import 'package:patient_tracker/views/hospitals.dart';
import 'package:patient_tracker/views/medical_records.dart';
import 'package:patient_tracker/views/profile.dart';
import 'package:patient_tracker/widgets/common/theme_switch.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:patient_tracker/views/chatbot_page.dart';

class HomeController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    final screens = [
      const Dashboard(),
      const MedicalRecordsPage(),
      const DoctorPage(),
      const HospitalPage(),
      const ProfileScreen(), // ✅ FIX nama class
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rumah Sakit Hermina"),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            tooltip: "Chatbot Rawat Jalan",
            onPressed: () {
              Get.to(() => const ChatbotPage());
            },
          )
        ],
      ),
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
            () => SalomonBottomBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changePage,
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard_rounded),
              title: const Text("Home"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.medical_services_outlined),
              title: const Text("Records"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.people_outline),
              title: const Text("Doctors"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.local_hospital_outlined),
              title: const Text("Hospitals"),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              title: const Text("Profile"),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: const ThemeSwitchIcon(size: 20),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: bgColor,
    );
  }
}
