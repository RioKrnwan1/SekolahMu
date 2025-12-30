//file announcement_model.dart digunakan untuk mendefinisikan struktur data pengumuman sekolah

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String priority;
  final DateTime date;
  final String createdBy;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.date,
    required this.createdBy,
  });

  // Copy with method for updates
  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    String? priority,
    DateTime? date,
    String? createdBy,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  // From JSON
  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      priority: json['priority'],
      date: DateTime.parse(json['date']),
      createdBy: json['createdBy'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'priority': priority,
      'date': date.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
