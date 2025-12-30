# SekolahMu

Aplikasi manajemen sekolah berbasis Flutter dengan Firebase sebagai backend. Dirancang untuk memudahkan administrasi sekolah dalam mengelola data siswa, guru, jadwal pelajaran, dan pengumuman.

## ✨ Fitur Utama

### Admin Dashboard
- 📊 Manajemen Data Siswa (CRUD)
- 👨‍🏫 Manajemen Data Guru dengan Jabatan
- 📅 Jadwal Pelajaran Multi-Kelas
- 📢 Pengumuman Sekolah
- 🔄 Role Switching (Admin ↔ Guru)

### Teacher Dashboard
- 👀 Lihat Data Siswa (Read-only)
- 👥 Lihat Data Guru (Read-only)
- 📖 Lihat Jadwal Pelajaran
- 📰 Lihat Pengumuman

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Backend:** Firebase
  - Authentication
  - Cloud Firestore
- **State Management:** Provider
- **Fonts:** Google Fonts

## 📋 Prerequisite

- Flutter SDK (3.0+)
- Dart SDK
- Firebase Project
- Android Studio / VS Code
- Emulator atau Physical Device

## 🚀 Cara Install

### 1. Clone Repository
```bash
git clone https://github.com/RioKrnwan1/SekolahMu.git
cd sekolahmu
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase
- Buat project di [Firebase Console](https://console.firebase.google.com)
- Download `google-services.json` untuk Android
- Letakkan di `android/app/google-services.json`
- Jalankan `flutterfire configure` (opsional)

### 4. Run Aplikasi
```bash
flutter run
```

## 📱 Fitur Detail

### Manajemen Siswa
- Tambah, Edit, Hapus data siswa
- Field: Nama, NISN, Kelas, Alamat, No. Telepon Orang Tua, Email
- Search & Filter

### Manajemen Guru
- Tambah, Edit, Hapus data guru
- Field: Nama, NIP, **Jabatan**, Mata Pelajaran, Email, No. Telepon, Alamat
- Search berdasarkan nama, NIP, jabatan, atau mata pelajaran

### Jadwal Pelajaran
- Multi-select kelas saat membuat jadwal baru
- Edit jadwal per kelas
- Organisasi per hari (Senin - Sabtu)
- Field: Mata Pelajaran, Guru, Waktu Mulai, Waktu Selesai

### Pengumuman
- Create, Read, Delete pengumuman
- Real-time update menggunakan Firestore Stream
- Visible untuk semua role (Admin & Guru)

## 🎨 UI/UX Design

- Modern Material Design
- Warna konsisten: Biru (`#6366F1`) sebagai primary color
- Google Fonts (Poppins)
- Responsive layout
- Smooth animations dan transitions

## 🔐 Security

- Firebase Authentication
- Role-based access control (Admin/Guru)
- Sensitive files (`google-services.json`, `firebase_options.dart`) excluded via `.gitignore`

## 📂 Struktur Project

```
lib/
├── constants.dart
├── main.dart
├── models/              # Data models
├── providers/           # State management
├── screens/
│   ├── admin/          # Admin screens
│   ├── teacher/        # Teacher screens
│   ├── auth/           # Login & Register
│   └── shared/         # Shared screens (Profile)
├── services/           # Firebase services
└── widgets/            # Reusable widgets
```

## 👨‍💻 Developer

**Rio Kurniawan**
- GitHub: [@RioKrnwan1](https://github.com/RioKrnwan1)

## 📄 License

This project is created for educational purposes.

---

**SekolahMu** - Memudahkan Administrasi Sekolah 🎓
