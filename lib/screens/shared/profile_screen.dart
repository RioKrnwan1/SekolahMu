//file profile_screen.dart digunakan untuk halaman profil sekolah (visi, misi, alamat)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';

// Halaman profil sekolah yang menampilkan informasi lengkap tentang sekolah
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Sekolah")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero banner matching dashboard style - bigger & centered
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // School icon with white background
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // School info - centered
                  Text(
                    "MI Muhammadiyah Tanjunganom",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "NPSN: 69725749 • Swasta",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Info Cards
            _buildInfoCard(
              icon: Icons.location_on,
              title: "Alamat",
              content:
                  "Jln Bukit Ampel No 5 Mranggen\nDesa Tanjunganom, Kec. Kepil\nKab. Wonosobo, Jawa Tengah",
              color: kAccentBlue,
            ),

            const SizedBox(height: 15),

            _buildInfoCard(
              icon: Icons.info_outline,
              title: "Info Sekolah",
              content:
                  "Bentuk: Madrasah Ibtidaiyah (MI)\nJenjang: DIKDAS\nStatus: Swasta\nNPSN: 69725749",
              color: kAccentOrange,
            ),

            const SizedBox(height: 15),

            _buildInfoCard(
              icon: Icons.visibility,
              title: "Visi",
              content:
                  "Mewujudkan generasi Islami yang cerdas, terampil, berakhlak mulia, dan berwawasan lingkungan.",
              color: kAccentGreen,
            ),

            const SizedBox(height: 15),

            _buildInfoCard(
              icon: Icons.flag,
              title: "Misi",
              content:
                  "1. Menyelenggarakan pendidikan berkualitas berbasis nilai Islam\n2. Mengembangkan potensi peserta didik secara optimal\n3. Membentuk karakter siswa yang berakhlak mulia\n4. Menciptakan lingkungan belajar yang kondusif",
              color: kAccentPink,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat kartu informasi sekolah
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
