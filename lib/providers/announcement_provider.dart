//file announcement_provider.dart digunakan untuk mengelola state pengumuman dari Firestore

import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../services/firestore_service.dart';

class AnnouncementProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<AnnouncementModel>> get announcements {
    return _firestoreService.getAnnouncements();
  }

  AnnouncementModel? latestAnnouncement;

  Future<void> addAnnouncement(AnnouncementModel announcement) async {
    await _firestoreService.addAnnouncement(announcement);
  }

  Future<void> updateAnnouncement(
    String id,
    AnnouncementModel updatedAnnouncement,
  ) async {
    await _firestoreService.updateAnnouncement(updatedAnnouncement);
  }

  Future<void> deleteAnnouncement(String id) async {
    await _firestoreService.deleteAnnouncement(id);
  }
}
