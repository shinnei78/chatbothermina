import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/core/theme/app_theme.dart';
import 'package:patient_tracker/widgets/common/app_logo.dart';
import 'package:patient_tracker/widgets/common/theme_switch.dart';
import 'package:patient_tracker/controllers/user_controller.dart';
import 'package:patient_tracker/core/models/user_model.dart'; // Import model untuk User

// Definisikan kelas DashboardItem
class DashboardItem {
  final String title;
  final IconData icon;
  final String route;
  final Color color;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.color,
  });
}

// Definisikan DashboardController
class DashboardController extends GetxController {
  final List<DashboardItem> dashboardItems = [
    DashboardItem(
      title: 'Medical Records',
      icon: Icons.assignment_outlined,
      route: '/medical_records',
      color: AppTheme.primaryBlue,
    ),
    DashboardItem(
      title: 'Medications',
      icon: Icons.medication_outlined,
      route: '/medication',
      color: AppTheme.secondaryGreen,
    ),
    DashboardItem(
      title: 'Doctors',
      icon: Icons.people_outline,
      route: '/doctors',
      color: Colors.purple,
    ),
    DashboardItem(
      title: 'Hospitals',
      icon: Icons.local_hospital_outlined,
      route: '/hospitals',
      color: Colors.orange,
    ),
    DashboardItem(
      title: 'Hospital Visits',
      icon: Icons.calendar_today_outlined,
      route: '/hospital_visits',
      color: Colors.teal,
    ),
    DashboardItem(
      title: 'Recommendations',
      icon: Icons.recommend_outlined,
      route: '/recommendations',
      color: Colors.red,
    ),
  ];

  final searchText = ''.obs;

  List<DashboardItem> get filteredItems {
    if (searchText.value.isEmpty) {
      return dashboardItems;
    }
    return dashboardItems
        .where((item) => item.title.toLowerCase().contains(searchText.value.toLowerCase()))
        .toList();
  }

  void search(String text) {
    searchText.value = text;
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController()); // Inisialisasi DashboardController
    final userController = Get.find<UserController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final user = userController.user;
      if (user == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isDarkMode
                          ? [AppTheme.darkBlue, const Color(0xFF1E1E1E)]
                          : [AppTheme.primaryBlue, AppTheme.accentBlue],
                    ),
                  ),
                  child: const Center(
                    child: AppLogo(
                      size: 80,
                      darkMode: true,
                    ),
                  ),
                ),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: ThemeSwitchIcon(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${user.firstName}',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rumah Sakit Terbaik Kamu',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/profile');
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              userController.getInitials(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      onChanged: controller.search,
                      decoration: InputDecoration(
                        hintText: 'Cari menu yang kamu inginkan...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Health Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildHealthStats(context, user),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Quick Access',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Obx(() => SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = controller.filteredItems[index];
                    return _buildDashboardItem(context, item, isDarkMode);
                  },
                  childCount: controller.filteredItems.length,
                ),
              ),
            )),
          ],
        ),
      );
    });
  }

  Widget _buildDashboardItem(BuildContext context, DashboardItem item, bool isDarkMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Get.toNamed(item.route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? item.color.withOpacity(0.2) : item.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 36, color: item.color),
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthStats(BuildContext context, UserModel user) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.favorite_outline, color: Theme.of(context).colorScheme.primary),
            ),
            title: const Text('Blood Type'),
            subtitle: Text(user.bloodType.isNotEmpty ? user.bloodType : '-'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.primary),
            ),
            title: const Text('Allergies'),
            subtitle: Text(user.allergies.isNotEmpty ? user.allergies.join(', ') : '-'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
