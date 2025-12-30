//file schedule_model.dart digunakan untuk mendefinisikan struktur data jadwal pelajaran

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  String id;
  String subject;
  String timeStart;
  String timeEnd;
  int classGrade;
  String day;
  String teacher;
  Color color;

  ScheduleModel({
    required this.id,
    required this.subject,
    required this.timeStart,
    required this.timeEnd,
    required this.classGrade,
    required this.day,
    required this.teacher,
    required this.color,
  });

  // Convert to JSON (preparation for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'classGrade': classGrade,
      'day': day,
      'teacher': teacher,
      'color': '#${color.value.toRadixString(16).padLeft(8, '0')}',
    };
  }

  // Create from JSON
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      subject: json['subject'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      classGrade: json['classGrade'],
      day: json['day'],
      teacher: json['teacher'],
      color: Color(int.parse(json['color'].substring(1), radix: 16)),
    );
  }
}
