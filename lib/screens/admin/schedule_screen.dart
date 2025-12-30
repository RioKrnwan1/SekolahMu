//file schedule_screen.dart digunakan untuk halaman kelola jadwal pelajaran (tambah, edit, hapus)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/schedule_model.dart';
import '../../services/firestore_service.dart';
import '../../main.dart';

// Halaman untuk mengelola jadwal pelajaran oleh Admin (Tambah, Ubah, Hapus per kelas dan hari)

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  // Layanan untuk mengakses basis data Firestore
  final FirestoreService _firestoreService = FirestoreService();

  // Variabel untuk memilih kelas (bawaan: kelas 1)
  int _selectedClass = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: kDays.length, vsync: this);
  }

  // Menghasilkan warna acak untuk jadwal
  Color pickRandomColor() {
    final colors = [kAccentBlue, kAccentPink, kAccentGreen, kAccentOrange];
    return colors[DateTime.now().millisecond % colors.length];
  }

  // Menampilkan jendela formulir untuk menambah atau mengubah jadwal
  void _showFormDialog({ScheduleModel? item}) {
    final isEdit = item != null;
    final subjectController = TextEditingController(text: item?.subject ?? "");
    final teacherController = TextEditingController(text: item?.teacher ?? "");

    TimeOfDay startTime = item != null
        ? TimeOfDay(
            hour: int.parse(item.timeStart.split(":")[0]),
            minute: int.parse(item.timeStart.split(":")[1]),
          )
        : const TimeOfDay(hour: 08, minute: 00);
    TimeOfDay endTime = item != null
        ? TimeOfDay(
            hour: int.parse(item.timeEnd.split(":")[0]),
            minute: int.parse(item.timeEnd.split(":")[1]),
          )
        : const TimeOfDay(hour: 09, minute: 30);

    String currentDay = kDays[_tabController.index];
    Set<int> selectedClasses = {
      item?.classGrade ?? _selectedClass,
    }; // Start with edited class (or current tab class if adding new)

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? "Edit Jadwal" : "Tambah Jadwal Baru",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  Text(
                    isEdit
                        ? "Kelas ${item.classGrade} - Hari $currentDay"
                        : "Hari $currentDay",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  if (!isEdit) ...[
                    const SizedBox(height: 15),
                    Text(
                      "Pilih Kelas",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(6, (index) {
                        final classNum = index + 1;
                        final isSelected = selectedClasses.contains(classNum);

                        return GestureDetector(
                          onTap: () {
                            setStateModal(() {
                              if (isSelected) {
                                selectedClasses.remove(classNum);
                              } else {
                                selectedClasses.add(classNum);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6366F1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6366F1)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              "Kelas $classNum",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Mata Pelajaran",
                    subjectController,
                    Icons.book,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField("Nama Guru", teacherController, Icons.person),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimePickerBtn(
                          context,
                          "Jam Mulai",
                          startTime,
                          (picked) => setStateModal(() => startTime = picked),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTimePickerBtn(
                          context,
                          "Jam Selesai",
                          endTime,
                          (picked) => setStateModal(() => endTime = picked),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () async {
                        if (subjectController.text.isEmpty ||
                            teacherController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Mata pelajaran dan guru harus diisi!",
                              ),
                            ),
                          );
                          return;
                        }

                        if (selectedClasses.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pilih minimal 1 kelas!"),
                            ),
                          );
                          return;
                        }

                        try {
                          if (isEdit) {
                            // Edit mode: update single schedule
                            final scheduleData = ScheduleModel(
                              id: item.id,
                              subject: subjectController.text,
                              timeStart:
                                  "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
                              timeEnd:
                                  "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}",
                              classGrade: item.classGrade,
                              day: currentDay,
                              teacher: teacherController.text,
                              color: item.color,
                            );
                            await _firestoreService.updateSchedule(
                              scheduleData,
                            );
                          } else {
                            // Add mode: create schedule for each selected class
                            for (final classNum in selectedClasses) {
                              final scheduleData = ScheduleModel(
                                id: "",
                                subject: subjectController.text,
                                timeStart:
                                    "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
                                timeEnd:
                                    "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}",
                                classGrade: classNum,
                                day: currentDay,
                                teacher: teacherController.text,
                                color: pickRandomColor(),
                              );
                              await _firestoreService.addSchedule(scheduleData);
                            }
                          }
                          if (context.mounted) Navigator.pop(context);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        }
                      },
                      child: Text(
                        isEdit ? "Simpan Perubahan" : "Tambah Jadwal",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => mainNavKey.currentState?.switchToTab(0),
        ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add, color: Colors.white),
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
            return Dismissible(
              key: Key(item.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) async {
                await _firestoreService.deleteSchedule(item.id);
                return false;
              },
              child: GestureDetector(
                onTap: () => _showFormDialog(item: item),
                child: Container(
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
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        filled: true,
        fillColor: kBackgroundColor,
      ),
    );
  }

  Widget _buildTimePickerBtn(
    BuildContext context,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onPicked,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFF6366F1)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} WIB",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
