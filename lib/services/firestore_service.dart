//file firestore_service.dart digunakan untuk operasi CRUD database Firestore (siswa, guru, jadwal, pengumuman)

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';
import '../models/teacher_model.dart';
import '../models/schedule_model.dart';
import '../models/announcement_model.dart';

// Layanan untuk semua operasi data (Tambah, Ubah, Hapus, Lihat) ke basis data Firestore
// Mengelola data: Siswa, Guru, Jadwal, Pengumuman
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection references
  final String _studentsCollection = 'students';
  final String _teachersCollection = 'teachers';
  final String _schedulesCollection = 'schedules';
  final String _announcementsCollection = 'announcements';

  // ========== STUDENTS ==========

  /// Get all students as a stream
  Stream<List<StudentModel>> getStudents() {
    return _db
        .collection(_studentsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => StudentModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  /// Add a new student
  Future<void> addStudent(StudentModel student) async {
    final data = student.toJson();
    data.remove('id'); // Remove id, Firestore will generate it
    await _db.collection(_studentsCollection).add(data);
  }

  /// Update an existing student
  Future<void> updateStudent(StudentModel student) async {
    final data = student.toJson();
    data.remove('id'); // Don't update the id field
    await _db.collection(_studentsCollection).doc(student.id).update(data);
  }

  /// Delete a student
  Future<void> deleteStudent(String id) async {
    await _db.collection(_studentsCollection).doc(id).delete();
  }

  // ========== TEACHERS ==========

  /// Get all teachers as a stream
  Stream<List<TeacherModel>> getTeachers() {
    return _db
        .collection(_teachersCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TeacherModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  /// Add a new teacher
  Future<void> addTeacher(TeacherModel teacher) async {
    final data = teacher.toJson();
    data.remove('id');
    await _db.collection(_teachersCollection).add(data);
  }

  /// Update an existing teacher
  Future<void> updateTeacher(TeacherModel teacher) async {
    final data = teacher.toJson();
    data.remove('id');
    await _db.collection(_teachersCollection).doc(teacher.id).update(data);
  }

  /// Delete a teacher
  Future<void> deleteTeacher(String id) async {
    await _db.collection(_teachersCollection).doc(id).delete();
  }

  // ========== SCHEDULES ==========

  /// Get all schedules as a stream
  Stream<List<ScheduleModel>> getSchedules() {
    return _db
        .collection(_schedulesCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ScheduleModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  /// Add a new schedule
  Future<void> addSchedule(ScheduleModel schedule) async {
    final data = schedule.toJson();
    data.remove('id');
    await _db.collection(_schedulesCollection).add(data);
  }

  /// Update an existing schedule
  Future<void> updateSchedule(ScheduleModel schedule) async {
    final data = schedule.toJson();
    data.remove('id');
    await _db.collection(_schedulesCollection).doc(schedule.id).update(data);
  }

  /// Delete a schedule
  Future<void> deleteSchedule(String id) async {
    await _db.collection(_schedulesCollection).doc(id).delete();
  }

  // ========== ANNOUNCEMENTS ==========

  /// Get all announcements as a stream
  Stream<List<AnnouncementModel>> getAnnouncements() {
    return _db
        .collection(_announcementsCollection)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AnnouncementModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  /// Add a new announcement
  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    final data = announcement.toJson();
    data.remove('id');
    await _db.collection(_announcementsCollection).add(data);
  }

  /// Update an existing announcement
  Future<void> updateAnnouncement(AnnouncementModel announcement) async {
    final data = announcement.toJson();
    data.remove('id');
    await _db
        .collection(_announcementsCollection)
        .doc(announcement.id)
        .update(data);
  }

  /// Delete an announcement
  Future<void> deleteAnnouncement(String id) async {
    await _db.collection(_announcementsCollection).doc(id).delete();
  }
}
