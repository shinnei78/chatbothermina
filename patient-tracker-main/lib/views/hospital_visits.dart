import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/core/theme/app_theme.dart';
import 'package:patient_tracker/widgets/common/theme_switch.dart';
import 'package:patient_tracker/controllers/hospital_visits_controller.dart';
import 'package:patient_tracker/models/hospital_visit-model.dart';
import 'package:patient_tracker/views/hospital_visits_detail_page.dart';

final HospitalVisitController hospitalVisitController =
Get.put(HospitalVisitController());

class HospitalVisitPage extends StatefulWidget {
  const HospitalVisitPage({super.key});

  @override
  _HospitalVisitPageState createState() => _HospitalVisitPageState();
}

class _HospitalVisitPageState extends State<HospitalVisitPage> {
  bool _isLoading = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _fetchHospitalVisits();
  }

  Future<void> _fetchHospitalVisits() async {
    setState(() => _isLoading = true);
    try {
      await hospitalVisitController.fetchVisits();
    } catch (e) {
      _showErrorSnackBar();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar() {
    Get.snackbar(
      'Error',
      'Failed to fetch hospital visits. Please try again later.',
      backgroundColor: AppTheme.error,
      colorText: AppTheme.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kunjungan Rumah Sakit'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ThemeSwitchIcon(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() => _searchText = value);
              },
              decoration: InputDecoration(
                labelText: "Cari",
                hintText: "Cari catatan kunjungan...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(child: _buildHospitalVisitListView()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "refresh",
            onPressed: _fetchHospitalVisits,
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Get.toNamed('/add_hospital_visit');
            },
            tooltip: 'Tambah Kunjungan',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalVisitListView() {
    return Obx(() {
      final visits = hospitalVisitController.hospitalVisits;
      final filteredVisits = visits.where((v) {
        return v.notes.toLowerCase().contains(_searchText.toLowerCase()) ||
            v.hospitalName.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();

      if (filteredVisits.isEmpty) {
        return _searchText.isEmpty ? _buildEmptyState() : _buildNoMatchState();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredVisits.length,
        itemBuilder: (context, index) {
          final visit = filteredVisits[index];
          return _buildHospitalVisitCard(visit);
        },
      );
    });
  }

  Widget _buildHospitalVisitCard(HospitalVisit visit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Get.to(() => HospitalVisitDetailPage(visit: visit)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                visit.hospitalName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 6),
                  Text(visit.visitDate),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 6),
                  Text('Dokter: ${visit.doctorName}'),
                ],
              ),
              const SizedBox(height: 4),
              Text('Catatan: ${visit.notes}'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.visibility_rounded, size: 16),
                  label: const Text('Lihat Detail'),
                  onPressed: () {
                    Get.to(() => HospitalVisitDetailPage(visit: visit));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("Belum ada kunjungan rumah sakit"),
    );
  }

  Widget _buildNoMatchState() {
    return const Center(
      child: Text("Tidak ada data yang cocok dengan pencarian"),
    );
  }
}
