//file role_provider.dart digunakan untuk mengelola role pengguna (admin/guru) di seluruh aplikasi

import 'package:flutter/material.dart';

enum UserRole { admin, teacher }

class RoleProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.admin; // Default role

  UserRole get currentRole => _currentRole;

  bool get isAdmin => _currentRole == UserRole.admin;
  bool get isTeacher => _currentRole == UserRole.teacher;

  String get roleName {
    switch (_currentRole) {
      case UserRole.admin:
        return 'Admin Sekolah';
      case UserRole.teacher:
        return 'Guru';
    }
  }

  void switchRole(UserRole role) {
    if (_currentRole != role) {
      _currentRole = role;
      notifyListeners();
    }
  }

  // Method untuk set role dari string (untuk integrasi dengan AuthProvider)
  void setRole(String roleString) {
    final role = roleString == 'admin' ? UserRole.admin : UserRole.teacher;
    switchRole(role);
  }

  void toggleRole() {
    _currentRole = _currentRole == UserRole.admin
        ? UserRole.teacher
        : UserRole.admin;
    notifyListeners();
  }
}
