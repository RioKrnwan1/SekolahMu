//file teacher_model.dart digunakan untuk mendefinisikan struktur data guru

class TeacherModel {
  String id;
  String name;
  String nip;
  String position; // Jabatan (Kepala Sekolah, Wakil Kepala, Guru, dll)
  String subject; // Mata pelajaran
  String phone;
  String email;
  String address;

  TeacherModel({
    required this.id,
    required this.name,
    required this.nip,
    required this.position,
    required this.subject,
    required this.phone,
    required this.email,
    required this.address,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nip': nip,
      'position': position,
      'subject': subject,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  // Create from JSON
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'],
      name: json['name'],
      nip: json['nip'],
      position: json['position'] ?? 'Guru', // Default: Guru untuk data lama
      subject: json['subject'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}
