import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationService {
  static void showPrayerNotification(String title) {
    showSimpleNotification(
      Text(
        "🕌 حان الآن وقت $title",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("توجه للصلاة الآن"),
      background: Colors.green,
      duration: const Duration(seconds: 5),
    );
  }
}
