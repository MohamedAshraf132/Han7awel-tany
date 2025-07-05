import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:han7awel_tany/core/services/location_service.dart';
import 'package:han7awel_tany/core/services/notification_service.dart';
import 'package:intl/intl.dart';
import '../data/models/prayer_model.dart';

class PrayersViewModel extends ChangeNotifier {
  List<PrayerModel> prayers = [];
  DateTime? _lastFetchedDate;

  final Box _prayersBox = Hive.box('prayers');

  PrayersViewModel() {
    fetchPrayerTimes();
  }

  /// تحميل مواقيت الصلاة لليوم الحالي فقط
  Future<void> fetchPrayerTimes() async {
    final today = DateTime.now();

    if (_lastFetchedDate != null &&
        _lastFetchedDate!.year == today.year &&
        _lastFetchedDate!.month == today.month &&
        _lastFetchedDate!.day == today.day) {
      return; // تم التحميل مسبقًا اليوم
    }

    _lastFetchedDate = today;

    final position = await LocationService.getCurrentLocation();
    final myCoordinates = position != null
        ? Coordinates(position.latitude, position.longitude)
        : Coordinates(30.0444, 31.2357); // fallback Cairo

    final params = CalculationMethod.egyptian.getParameters();
    final prayerTimes = PrayerTimes.today(myCoordinates, params);

    prayers = [
      PrayerModel(
        name: 'الفجر',
        time: prayerTimes.fajr,
        isPrayed: _getPrayerStatus('الفجر', today),
      ),
      PrayerModel(
        name: 'الظهر',
        time: prayerTimes.dhuhr,
        isPrayed: _getPrayerStatus('الظهر', today),
      ),
      PrayerModel(
        name: 'العصر',
        time: prayerTimes.asr,
        isPrayed: _getPrayerStatus('العصر', today),
      ),
      PrayerModel(
        name: 'المغرب',
        time: prayerTimes.maghrib,
        isPrayed: _getPrayerStatus('المغرب', today),
      ),
      PrayerModel(
        name: 'العشاء',
        time: prayerTimes.isha,
        isPrayed: _getPrayerStatus('العشاء', today),
      ),
    ];

    notifyListeners();
    _scheduleOverlayNotifications();
  }

  /// تأكيد الصلاة
  void markAsPrayed(int index) {
    prayers[index].isPrayed = true;
    final key = _getPrayerKey(prayers[index].name, DateTime.now());
    _prayersBox.put(key, true);
    notifyListeners();
  }

  /// إلغاء التأكيد
  void unmarkAsPrayed(int index) {
    prayers[index].isPrayed = false;
    final key = _getPrayerKey(prayers[index].name, DateTime.now());
    _prayersBox.put(key, false);
    notifyListeners();
  }

  /// هل هذه الصلاة مؤداة بالفعل؟
  bool _getPrayerStatus(String prayerName, DateTime date) {
    final key = _getPrayerKey(prayerName, date);
    return _prayersBox.get(key, defaultValue: false);
  }

  /// توليد مفتاح مميز لكل صلاة وتاريخها
  String _getPrayerKey(String prayerName, DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return '$formattedDate-$prayerName';
  }

  /// جدولة الإشعارات لكل صلاة لم تحن بعد
  void _scheduleOverlayNotifications() {
    for (var prayer in prayers) {
      final duration = prayer.time.difference(DateTime.now());
      if (duration.inSeconds > 0) {
        Timer(duration, () {
          NotificationService.showPrayerNotification(prayer.name);
        });
      }
    }
  }

  /// تنسيق الوقت للعرض
  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  /// ✅ عدد الصلوات المؤداة
  int get prayedCount => prayers.where((p) => p.isPrayed).length;

  /// ✅ عدد الصلوات الكلي
  int get totalPrayers => prayers.length;

  /// ✅ الوقت المتبقي حتى الصلاة القادمة (إن وُجدت)
  Duration? get nextPrayerCountdown {
    final now = DateTime.now();
    final upcoming = prayers.firstWhere(
      (p) => p.time.isAfter(now),
      orElse: () =>
          PrayerModel(name: '', time: now.add(const Duration(days: 1))),
    );
    return upcoming.name.isEmpty ? null : upcoming.time.difference(now);
  }

  /// ✅ اسم الصلاة القادمة
  String? get nextPrayerName {
    final now = DateTime.now();
    final upcoming = prayers.firstWhere(
      (p) => p.time.isAfter(now),
      orElse: () => PrayerModel(name: '', time: now),
    );
    return upcoming.name.isEmpty ? null : upcoming.name;
  }
}
