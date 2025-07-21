import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_tracker/controllers/medical-record_controller.dart';
import 'package:patient_tracker/models/medical_record.dart';  // Pastikan MedicalRecord sudah diimpor
import 'package:patient_tracker/views/add_medical_record.dart';  // Halaman untuk menambah rekam medis
import 'package:patient_tracker/views/medical_record_detail_page.dart';  // Halaman untuk melihat detail rekam medis

MedicalRecordsController medicalController = Get.put(MedicalRecordsController());

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({super.key});

  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  bool _isLoading = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _fetchMedicalRecords();
  }

  Future<void> _fetchMedicalRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetching records from Firestore
      await medicalController.fetchMedicalRecords();
    } catch (e) {
      print('Error fetching medical records: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekam Medis Anda'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Buka halaman AddMedicalRecordPage saat tombol Add ditekan
              Get.to(() => AddMedicalRecordPage());
            },
          )
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
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Cari",
                hintText: "Cari rekam medis Anda...",
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
          Expanded(child: _buildMedicalRecordListView()),
        ],
      ),
    );
  }

  Widget _buildMedicalRecordListView() {
    return Obx(() {
      if (medicalController.medicalRecords.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada rekam medis tersedia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      } else {
        var displayedMedicalRecords = medicalController.medicalRecords
            .where((medicalRecord) =>
            medicalRecord.description
                .toLowerCase()
                .contains(_searchText.toLowerCase()))
            .toList();

        if (displayedMedicalRecords.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ditemukan rekam medis yang sesuai',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: displayedMedicalRecords.length,
          itemBuilder: (context, index) {
            return _buildMedicalRecordCard(index, displayedMedicalRecords);
          },
        );
      }
    });
  }

  Widget _buildMedicalRecordCard(int index, List<MedicalRecord> medicalRecords) {
    final medicalRecord = medicalRecords[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => MedicalRecordDetailPage(medicalRecord: medicalRecord));  // Tampilkan halaman detail saat diklik
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medical_information_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No Registrasi: ${medicalRecord.noRegistrasi}"),
                    Text("Judul: ${medicalRecord.judul}"),
                    Text("Nama Dokter: ${medicalRecord.namaDokter}"),
                    Text("Tanggal Periksa: ${medicalRecord.record_date}"),
                    Text("Rumah Sakit: ${medicalRecord.rumahSakit}"),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Get.to(() => MedicalRecordDetailPage(medicalRecord: medicalRecord)); // Klik untuk lihat detail
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
