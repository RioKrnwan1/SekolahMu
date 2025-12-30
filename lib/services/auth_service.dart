//file auth_service.dart digunakan untuk menangani semua operasi autentikasi Firebase (login, register, logout)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

// Layanan untuk menangani semua operasi autentikasi pengguna
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Mendapatkan pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Stream perubahan status autentikasi
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mendaftarkan pengguna baru
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Buat akun di Firebase Authentication
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        throw 'Gagal membuat akun';
      }

      // Buat profil pengguna
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      // Simpan profil ke Firestore
      await _db.collection('users').doc(user.uid).set(userModel.toMap());

      // Update display name di Firebase Auth
      await user.updateDisplayName(name);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Login pengguna
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Login dengan Firebase Authentication
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw 'Login gagal';
      }

      // Ambil profil dari Firestore
      final userProfile = await getUserProfile(user.uid);

      // Jika profil tidak ada di Firestore, throw error
      if (userProfile == null) {
        throw 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      }

      return userProfile;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Logout pengguna
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Gagal logout: $e';
    }
  }

  // Mendapatkan profil pengguna dari Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, uid);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil profil: $e';
    }
  }

  // Update profil pengguna
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).update(user.toMap());

      // Update display name di Firebase Auth jika nama berubah
      if (_auth.currentUser != null &&
          _auth.currentUser!.displayName != user.name) {
        await _auth.currentUser!.updateDisplayName(user.name);
      }
    } catch (e) {
      throw 'Gagal update profil: $e';
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Gagal mengirim email reset: $e';
    }
  }

  // Menangani error Firebase Authentication
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan login.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
        return 'Email tidak terdaftar. Silakan periksa kembali email Anda.';
      case 'wrong-password':
        return 'Password salah. Silakan periksa kembali password Anda.';
      case 'invalid-credential':
        return 'Email atau password salah. Silakan periksa kembali.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan login. Coba lagi nanti.';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
      case 'channel-error':
        return 'Harap isi email dan password dengan benar.';
      default:
        return 'Login gagal: ${e.message ?? e.code}';
    }
  }
}
