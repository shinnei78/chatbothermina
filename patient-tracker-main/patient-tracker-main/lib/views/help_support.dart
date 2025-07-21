import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/core/theme/app_theme.dart';
import 'package:patient_tracker/widgets/common/theme_switch.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
           _buildSectionCard(
            context,
            title: 'Pertanyaan Umum',
            icon: Icons.question_answer_outlined,
            color: AppTheme.primaryBlue,
            children: [
              _buildFaqItem(
                context,
                question: 'Bagaimana cara menambahkan rekam medis baru?',
                answer:
                    'Saat ini rekam medis dikelola oleh penyedia layanan kesehatan. Di pembaruan selanjutnya, Anda dapat menambahkan rekam medis secara manual.',
              ),
              _buildFaqItem(
                context,
                question: 'Bagaimana cara membuat janji dengan dokter?',
                answer:
                    'Buka halaman Dokter, pilih dokter, lalu tekan "Book Appointment" dan pilih tanggal serta waktu yang tersedia.',
              ),
              _buildFaqItem(
                context,
                question: 'Apakah data saya aman?',
                answer:
                    'Ya. Semua data medis dienkripsi secara standar industri dan tidak dibagikan tanpa persetujuan Anda.',
              ),
              _buildFaqItem(
                context,
                question: 'Apa nomor Call Center Hermina?',
                answer:
                    'Untuk informasi umum atau pendaftaran, hubungi Call Center Hermina di **1500 –488** :contentReference[oaicite:1]{index=1}.',
              ),
              _buildFaqItem(
                context,
                question: 'Bagaimana cara menghubungi dukungan aplikasi?',
                answer:
                    'Untuk bantuan teknis terkait aplikasi, kirim email ke **apps@herminahospitals.com** :contentReference[oaicite:2]{index=2}.',
              ),
              _buildFaqItem(
                context,
                question: 'Di mana rumah sakit Hermina berada?',
                answer:
                    'Hermina memiliki **52 rumah sakit** di **63 kota** dalam **17 provinsi** di Indonesia :contentReference[oaicite:3]{index=3}.',
              ),
            ],
          ),

          const SizedBox(height: 20),
          _buildSectionCard(
            context,
            title: 'Kontak Dukungan',
            icon: Icons.support_agent_outlined,
            color: AppTheme.secondaryGreen,
            children: [
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email Dukungan Aplikasi'),
                subtitle: const Text('apps@herminahospitals.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.snackbar(
                      'Hubungi Email',
                      'Fitur email segera hadir',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Call Center Hermina'),
                subtitle: const Text('1500 –488'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.snackbar(
                      'Hubungi Nomor',
                      'Fungsi panggilan segera tersedia',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat_outlined),
                title: const Text('Live Chat'),
                subtitle: const Text('Belum tersedia'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.snackbar(
                      'Live Chat',
                      'Fitur Live Chat segera hadir',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSectionCard(
            context,
            title: 'Informasi Aplikasi',
            icon: Icons.info_outline,
            color: Colors.purple,
            children: [
              ListTile(
                title: const Text('Versi Aplikasi'),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: const Text('Syarat & Ketentuan'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.snackbar(
                      'Syarat & Ketentuan',
                      'Fitur segera hadir',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
              ListTile(
                title: const Text('Kebijakan Privasi'),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    Get.snackbar(
                      'Kebijakan Privasi',
                      'Fitur segera hadir',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
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
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
