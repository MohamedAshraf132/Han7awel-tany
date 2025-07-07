import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final _player = AudioPlayer();
  static void showNightPrayerReminder() {
    showSimpleNotification(
      const Text(
        "🌙 حان وقت قيام الليل",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("لا تنسَ الوقوف بين يدي الله"),
      background: Colors.indigo,
      duration: Duration(seconds: 6),
    );
  }

  static void showReminderBeforePrayer(String title) {
    showSimpleNotification(
      Text(
        "⌛ اقترب وقت $title",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("استعد للصلاة"),
      background: Colors.orange.shade700,
      duration: const Duration(seconds: 4),
    );
  }

  static void showPrayerNotification(String title) async {
    try {
      // ✅ تشغيل صوت المنبه من الأصول
      await _player.play(AssetSource('assets/sounds/alarm.mp3'));
    } catch (e) {
      debugPrint("حدث خطأ أثناء تشغيل الصوت: $e");
    }

    // ✅ عرض إشعار Overlay
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
