//file teachers_screen.dart digunakan untuk halaman kelola data guru (tambah, edit, hapus)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/teacher_model.dart';
import '../../services/firestore_service.dart';

// Halaman untuk mengelola data guru oleh Admin (Tambah, Ubah, Hapus, Cari)
class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // Filter guru berdasarkan pencarian
  List<TeacherModel> _filterTeachers(List<TeacherModel> teachers) {
    if (_searchQuery.isEmpty) return teachers;
    return teachers.where((teacher) {
      return teacher.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teacher.nip.contains(_searchQuery) ||
          teacher.position.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          teacher.subject.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  // Form dialog untuk tambah/edit guru
  void _showFormDialog({TeacherModel? teacher}) {
    final isEdit = teacher != null;
    final nameController = TextEditingController(text: teacher?.name ?? "");
    final nipController = TextEditingController(text: teacher?.nip ?? "");
    final positionController = TextEditingController(
      text: teacher?.position ?? "",
    );
    final subjectController = TextEditingController(
      text: teacher?.subject ?? "",
    );
    final phoneController = TextEditingController(text: teacher?.phone ?? "");
    final emailController = TextEditingController(text: teacher?.email ?? "");
    final addressController = TextEditingController(
      text: teacher?.address ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? "Edit Data Guru" : "Tambah Guru Baru",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField("Nama Lengkap", nameController, Icons.person),
                const SizedBox(height: 15),
                _buildTextField(
                  "NIP",
                  nipController,
                  Icons.badge,
                  isNumber: true,
                ),
                const SizedBox(height: 15),
                _buildTextField("Jabatan", positionController, Icons.work),
                const SizedBox(height: 15),
                _buildTextField(
                  "Mata Pelajaran",
                  subjectController,
                  Icons.book,
                ),
                const SizedBox(height: 15),
                _buildTextField("Email", emailController, Icons.email),
                const SizedBox(height: 15),
                _buildTextField(
                  "No. Telepon",
                  phoneController,
                  Icons.phone,
                  isNumber: true,
                ),
                const SizedBox(height: 15),
                _buildTextField("Alamat", addressController, Icons.home),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          nipController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Nama dan NIP harus diisi!"),
                          ),
                        );
                        return;
                      }

                      final teacherData = TeacherModel(
                        id: teacher?.id ?? "",
                        name: nameController.text,
                        nip: nipController.text,
                        position: positionController.text,
                        subject: subjectController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                      );

                      try {
                        if (isEdit) {
                          await _firestoreService.updateTeacher(teacherData);
                        } else {
                          await _firestoreService.addTeacher(teacherData);
                        }
                        if (context.mounted) Navigator.pop(context);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      }
                    },
                    child: Text(
                      isEdit ? "Simpan Perubahan" : "Tambah Guru",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Future<bool> _confirmDelete(TeacherModel teacher) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Guru?"),
        content: Text(
          "Yakin ingin menghapus ${teacher.name} dari daftar guru?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(
          "Data Guru",
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Header dengan search
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Cari nama, NIP, atau mata pelajaran...",
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
          ),
          // List guru dengan swipe to delete
          Expanded(
            child: StreamBuilder<List<TeacherModel>>(
              stream: _firestoreService.getTeachers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final teachers = snapshot.data ?? [];
                final filteredTeachers = _filterTeachers(teachers);

                if (filteredTeachers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          "Tidak ada data guru",
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
                  itemCount: filteredTeachers.length,
                  itemBuilder: (context, index) {
                    final teacher = filteredTeachers[index];
                    return Dismissible(
                      key: Key(teacher.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        final confirmed = await _confirmDelete(teacher);
                        if (confirmed) {
                          try {
                            await _firestoreService.deleteTeacher(teacher.id);
                            return true;
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                            return false;
                          }
                        }
                        return false;
                      },
                      child: GestureDetector(
                        onTap: () => _showFormDialog(teacher: teacher),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kPrimaryColor.withOpacity(
                                    0.1,
                                  ),
                                  child: Text(
                                    teacher.name[0].toUpperCase(),
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        teacher.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "NIP: ${teacher.nip}",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.work,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            teacher.position,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.book,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            teacher.subject,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            teacher.phone,
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
                                Icon(
                                  Icons.edit,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
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
