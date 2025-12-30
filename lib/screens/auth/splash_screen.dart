//file splash_screen.dart digunakan untuk layar awal yang memeriksa status autentikasi pengguna

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/role_provider.dart';
import '../admin/admin_dashboard_screen.dart';
import '../teacher/teacher_dashboard_screen.dart';
import 'login_screen.dart';

// Layar splash untuk memeriksa status autentikasi saat app dibuka
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Tunggu sebentar untuk splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final roleProvider = Provider.of<RoleProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      // User sudah login, set role dan navigate ke dashboard
      final userRole = authProvider.currentUser!.role;
      roleProvider.setRole(userRole);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => userRole == 'admin'
              ? const AdminDashboardScreen()
              : const TeacherDashboardScreen(),
        ),
      );
    } else {
      // User belum login, navigate ke LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 100, color: Colors.white),
              SizedBox(height: 24),
              Text(
                'SekolahMu',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
