//file teacher_schedule_view_screen.dart digunakan untuk halaman guru melihat jadwal mengajar (read-only)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/schedule_model.dart';
import '../../services/firestore_service.dart';

// Halaman untuk guru melihat jadwal mengajar (hanya dapat dilihat, tidak dapat diubah)

class TeacherScheduleViewScreen extends StatefulWidget {
  const TeacherScheduleViewScreen({super.key});

  @override
  State<TeacherScheduleViewScreen> createState() =>
      _TeacherScheduleViewScreenState();
}

class _TeacherScheduleViewScreenState extends State<TeacherScheduleViewScreen>
    with SingleTickerProviderStateMixin {
  // Layanan untuk mengakses basis data Firestore (hanya lihat)
  final FirestoreService _firestoreService = FirestoreService();

  // Variabel untuk memilih kelas
  int _selectedClass = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: kDays.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Pelajaran"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF6366F1),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF6366F1),
          tabs: kDays.map((day) => Tab(text: day)).toList(),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 6,
              itemBuilder: (context, index) {
                int classNum = index + 1;
                bool isSelected = _selectedClass == classNum;
                return GestureDetector(
                  onTap: () => setState(() => _selectedClass = classNum),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "Kelas $classNum",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: kDays.map((day) => _buildScheduleList(day)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(String day) {
    return StreamBuilder<List<ScheduleModel>>(
      stream: _firestoreService.getSchedules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allSchedules = snapshot.data ?? [];
        final filteredData = allSchedules
            .where((s) => s.classGrade == _selectedClass && s.day == day)
            .toList();
        filteredData.sort((a, b) => a.timeStart.compareTo(b.timeStart));

        if (filteredData.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 10),
                Text(
                  "Belum ada jadwal",
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final item = filteredData[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: item.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.subject,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.teacher,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${item.timeStart} - ${item.timeEnd}",
                          style: TextStyle(
                            color: item.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
