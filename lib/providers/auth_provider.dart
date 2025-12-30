//file auth_provider.dart digunakan untuk...

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// Provider untuk mengelola state autentikasi di seluruh aplikasi
class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    // Listen untuk perubahan auth state
    _authService.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser != null) {
        // User login, ambil profil dari Firestore
        await _loadUserProfile(firebaseUser.uid);
      } else {
        // User logout
        _currentUser = null;
        notifyListeners();
      }
    });
  }

  // Memuat profil pengguna dari Firestore
  Future<void> _loadUserProfile(String uid) async {
    try {
      final userProfile = await _authService.getUserProfile(uid);
      _currentUser = userProfile;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Mendaftarkan pengguna baru
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('🔑 Attempting login for: $email');
      final user = await _authService.signIn(email: email, password: password);
      print('🔑 Login result - User: ${user?.email}, Role: ${user?.role}');

      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      print(
        '🔑 AuthProvider state - isAuthenticated: $isAuthenticated, currentUser: ${_currentUser?.email}',
      );
      return user != null;
    } catch (e) {
      print('❌ Login error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout pengguna
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update profil pengguna
  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.updateUserProfile(updatedUser);
      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Membersihkan error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
