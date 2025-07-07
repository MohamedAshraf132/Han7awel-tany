import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final _player = AudioPlayer();

  /// ⏰ تذكير بقيام الليل
  static void showNightPrayerReminder() {
    showSimpleNotification(
      const Text(
        "🌙 حان وقت قيام الليل",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: const Text("لا تنسَ الوقوف بين يدي الله"),
      background: Colors.indigo,
      duration: const Duration(seconds: 6),
    );
  }

  /// 📖 تذكير بورد القرآن اليومي
  static void showDailyQuranReminder() {
    showSimpleNotification(
      const Text("📖 لا تنس وردك اليومي من القرآن"),
      subtitle: const Text("راجع وردك واقرأ ولو صفحة اليوم ❤️"),
      background: Colors.deepPurple,
      duration: const Duration(seconds: 5),
    );
  }

  /// ✅ إشعار عند إتمام ورد اليوم
  static void showQuranSuccessNotification({required String message}) {
    showSimpleNotification(
      const Text("✅ تم إنجاز ورد اليوم"),
      subtitle: const Text("أحسنت! استمر على طاعة الله 🌸"),
      background: Colors.green,
      duration: const Duration(seconds: 4),
    );
  }

  /// ⌛ تذكير قبل الصلاة
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

  /// 🕌 إشعار وقت الصلاة + صوت
  static void showPrayerNotification(String title) async {
    try {
      await _player.play(AssetSource('assets/sounds/alarm.mp3'));
    } catch (e) {
      debugPrint("حدث خطأ أثناء تشغيل الصوت: $e");
    }

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
