//file student_model.dart digunakan untuk mendefinisikan struktur data siswa

class StudentModel {
  String id;
  String name;
  String nisn;
  int classGrade;
  String gender;
  String address;
  String phone;
  String birthDate;

  StudentModel({
    required this.id,
    required this.name,
    required this.nisn,
    required this.classGrade,
    required this.gender,
    required this.address,
    required this.phone,
    required this.birthDate,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nisn': nisn,
      'classGrade': classGrade,
      'gender': gender,
      'address': address,
      'phone': phone,
      'birthDate': birthDate,
    };
  }

  // Create from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      nisn: json['nisn'],
      classGrade: json['classGrade'],
      gender: json['gender'],
      address: json['address'],
      phone: json['phone'],
      birthDate: json['birthDate'],
    );
  }
}
