//file user_model.dart digunakan untuk mendefinisikan struktur data pengguna (admin/guru)

import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk menyimpan data pengguna
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  // Konversi dari Map (Firestore) ke UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'teacher',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Konversi dari UserModel ke Map (untuk Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Duplikasi object dengan perubahan tertentu
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
