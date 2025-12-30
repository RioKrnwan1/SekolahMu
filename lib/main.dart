//file main.dart digunakan sebagai entry point aplikasi, setup Firebase dan State Management

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'providers/announcement_provider.dart';
import 'providers/role_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/schedule_screen.dart';
import 'screens/teacher/teacher_dashboard_screen.dart';
import 'screens/teacher/teacher_schedule_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize date formatting
  await initializeDateFormatting('id_ID', null);

  runApp(const SimMutaApp());
}

class SimMutaApp extends StatelessWidget {
  const SimMutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
      ],
      child: MaterialApp(
        title: 'SekolahMu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
          appBarTheme: const AppBarTheme(
            backgroundColor: kBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: kPrimaryColor),
            titleTextStyle: TextStyle(
              color: kPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            // If user is authenticated, show MainNavScreen with bottom nav
            if (authProvider.isAuthenticated &&
                authProvider.currentUser != null) {
              return MainNavScreen(key: mainNavKey);
            }
            // If still checking auth state, show SplashScreen
            if (authProvider.isLoading) {
              return const SplashScreen();
            }
            // Not authenticated, show LoginScreen
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

// --- NAVIGASI UTAMA (BOTTOM BAR)
final GlobalKey<_MainNavScreenState> mainNavKey =
    GlobalKey<_MainNavScreenState>();

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Sync RoleProvider with authenticated user's role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final roleProvider = Provider.of<RoleProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        roleProvider.setRole(authProvider.currentUser!.role);
      }
    });
  }

  // Method untuk switch tab dari luar (dipanggil dari Dashboard)
  void switchToTab(int index) {
    if (index >= 0 && index < 3) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleProvider>(
      builder: (context, roleProvider, _) {
        // Daftar Halaman berdasarkan role
        final List<Widget> screens = roleProvider.isAdmin
            ? [
                const AdminDashboardScreen(), // Admin Dashboard
                const ScheduleScreen(), // Jadwal (Admin bisa CRUD)
                const PlaceholderScreen(title: "Menu Lainnya"),
              ]
            : [
                const TeacherDashboardScreen(), // Teacher Dashboard
                const TeacherScheduleViewScreen(), // Jadwal Mengajar (Read-only)
                const PlaceholderScreen(title: "Menu Lainnya"),
              ];

        return Scaffold(
          // Body akan berganti sesuai index yang dipilih
          body: IndexedStack(index: _selectedIndex, children: screens),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, "Beranda"),
              _buildNavItem(1, Icons.calendar_month_rounded, "Jadwal"),
              _buildNavItem(2, Icons.settings, "Lainnya"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 10,
          vertical: 10,
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? kPrimaryColor : Colors.white70),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- Placeholder Screen ---
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(
              "$title sedang dikembangkan",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
