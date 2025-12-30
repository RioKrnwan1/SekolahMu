//file students_view_screen.dart digunakan untuk halaman guru melihat data siswa (read-only)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/student_model.dart';
import '../../services/firestore_service.dart';

// Halaman untuk guru melihat data siswa (read-only, tidak bisa edit)
class StudentsViewScreen extends StatefulWidget {
  const StudentsViewScreen({super.key});

  @override
  State<StudentsViewScreen> createState() => _StudentsViewScreenState();
}

class _StudentsViewScreenState extends State<StudentsViewScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedClass = 1;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Filter siswa berdasarkan kelas dan pencarian
  List<StudentModel> _filterStudents(List<StudentModel> students) {
    var filtered = students
        .where((s) => s.classGrade == _selectedClass)
        .toList();
    if (_searchQuery.isEmpty) return filtered;
    return filtered.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.nisn.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          "Data Siswa",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header dengan filter dan search
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Cari nama atau NISN...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Class filter tabs
                SizedBox(
                  height: 45,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final classNum = index + 1;
                      final isSelected = _selectedClass == classNum;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedClass = classNum),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              "Kelas $classNum",
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? kPrimaryColor
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // List siswa
          Expanded(
            child: StreamBuilder<List<StudentModel>>(
              stream: _firestoreService.getStudents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final students = snapshot.data ?? [];
                final filteredStudents = _filterStudents(students);

                if (filteredStudents.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Tidak ada data siswa",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: CircleAvatar(
                          backgroundColor: kPrimaryColor.withOpacity(0.1),
                          child: Text(
                            student.name[0].toUpperCase(),
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          student.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              "NISN: ${student.nisn}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(
                                  Icons.class_,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Kelas ${student.classGrade}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Icon(
                                  student.gender == "L"
                                      ? Icons.male
                                      : Icons.female,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  student.gender == "L"
                                      ? "Laki-laki"
                                      : "Perempuan",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
