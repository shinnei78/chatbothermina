import 'package:flutter/material.dart';
import 'package:patient_tracker/core/theme/app_theme.dart';
import 'package:patient_tracker/widgets/common/theme_switch.dart';

class UserGuidePage extends StatelessWidget {
  const UserGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ThemeSwitchIcon(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/back_1.jpg',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                ),
              ),
              child: Center(
                child: Text(
                  'Rumah Sakit Hermina',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Quick Guide',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            // Help cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildHelpCard(
                    context,
                    title: 'Medical Records',
                    description:
                        'View and manage your medical history, test results, and diagnoses',
                    icon: Icons.folder_special_rounded,
                  ),
                  _buildHelpCard(
                    context,
                    title: 'Medications',
                    description:
                        'Track your prescribed medications, dosages, and schedules',
                    icon: Icons.medication_rounded,
                  ),
                  _buildHelpCard(
                    context,
                    title: 'Doctors',
                    description:
                        'Find doctors, book appointments, and manage your consultations',
                    icon: Icons.medical_services_rounded,
                  ),
                  _buildHelpCard(
                    context,
                    title: 'Hospitals',
                    description:
                        'Locate nearby hospitals and access your visit history',
                    icon: Icons.local_hospital_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Help Topics',
                  hintText: 'Type your question or keyword',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                onChanged: (value) {
                  // Implement search functionality here
                },
              ),
            ),
            const SizedBox(height: 24),
            // FAQ section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pertanyaan Umum',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildFaqItem(
                    context,
                    question: 'Seberapa aman data saya?',
                    answer:
                        'Informasi medis Anda dienkripsi dan disimpan dengan aman. Kami mengikuti protokol privasi yang ketat dan mematuhi regulasi kesehatan untuk menjaga kerahasiaan data Anda.',
                  ),
                  _buildFaqItem(
                    context,
                    question: 'Bagaimana cara membuat janji dengan dokter?',
                    answer:
                        'Buka halaman Dokter, pilih dokter yang diinginkan, lalu tekan tombol "Book Appointment" dan pilih tanggal serta waktu yang tersedia.',
                  ),
                  _buildFaqItem(
                    context,
                    question: 'Bisakah saya membagikan rekam medis ke dokter?',
                    answer:
                        'Ya! Dari bagian Rekam Medis, pilih data yang ingin dibagikan, lalu tekan tombol "Share" dan pilih dokter tujuan.',
                  ),
                  _buildFaqItem(
                    context,
                    question: 'Bagaimana cara mengatur pengingat obat?',
                    answer:
                        'Masuk ke bagian Obat, pilih obat yang ingin diatur pengingatnya, tekan "Set Reminder", dan pilih jadwal notifikasi yang diinginkan.',
                  ),
                  _buildFaqItem(
                    context,
                    question: 'Apa nomor call center Hermina?',
                    answer:
                        'Untuk informasi umum atau pendaftaran, Anda dapat menghubungi Call Center Hermina di nomor **1500‑488** :contentReference[oaicite:1]{index=1}.',
                  ),
                  _buildFaqItem(
                    context,
                    question: 'Bagaimana cara mendapatkan dukungan teknis aplikasi?',
                    answer:
                        'Untuk masalah teknis terkait aplikasi mobile, silakan kirim email ke **apps@herminahospitals.com** :contentReference[oaicite:2]{index=2}.',
                  ),
                ],
              ),
            ),
            // Contact Info
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butuh Bantuan Lebih Lanjut?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'apps@herminahospitals.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '1500‑488',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      childrenPadding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          answer,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
