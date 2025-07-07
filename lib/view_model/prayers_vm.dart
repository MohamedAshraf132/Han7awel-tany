import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:han7awel_tany/core/services/location_service.dart';
import 'package:han7awel_tany/core/services/notification_service.dart';
import 'package:intl/intl.dart';
import '../models/prayer_model.dart';

class PrayersViewModel extends ChangeNotifier {
  List<PrayerModel> prayers = [];
  final Box _prayersBox = Hive.box('prayers');

  PrayersViewModel() {
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final savedTimes = _prayersBox.get('times_$formattedDate');
    if (savedTimes != null) {
      prayers = (savedTimes as List).map((item) {
        final map = Map<String, dynamic>.from(item);
        return PrayerModel(
          name: map['name'],
          time: DateTime.parse(map['time']),
          isPrayed: _getPrayerStatus(map['name'], today),
        );
      }).toList();

      notifyListeners();
      _scheduleOverlayNotifications();
      _scheduleQiyamNotification();
      return;
    }

    try {
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

      final timesToSave = prayers
          .map((p) => {'name': p.name, 'time': p.time.toIso8601String()})
          .toList();
      _prayersBox.put('times_$formattedDate', timesToSave);

      notifyListeners();
      _scheduleOverlayNotifications();
      _scheduleQiyamNotification();
    } catch (e) {
      print('❌ فشل في حساب مواقيت الصلاة: $e');
    }
  }

  void markAsPrayed(int index) {
    prayers[index].isPrayed = true;
    final key = _getPrayerKey(prayers[index].name, DateTime.now());
    _prayersBox.put(key, true);
    notifyListeners();
  }

  void unmarkAsPrayed(int index) {
    prayers[index].isPrayed = false;
    final key = _getPrayerKey(prayers[index].name, DateTime.now());
    _prayersBox.put(key, false);
    notifyListeners();
  }

  bool _getPrayerStatus(String prayerName, DateTime date) {
    final key = _getPrayerKey(prayerName, date);
    return _prayersBox.get(key, defaultValue: false);
  }

  String _getPrayerKey(String prayerName, DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return '$formattedDate-$prayerName';
  }

  void _scheduleOverlayNotifications() {
    final now = DateTime.now();
    for (var prayer in prayers) {
      final timeUntilPrayer = prayer.time.difference(now);

      // ⏰ إشعار قبل الصلاة بدقيقة
      final before = prayer.time.subtract(const Duration(minutes: 1));
      if (before.isAfter(now)) {
        Timer(before.difference(now), () {
          NotificationService.showReminderBeforePrayer(prayer.name);
        });
      }

      // 🕌 إشعار وقت الصلاة
      if (timeUntilPrayer.inSeconds > 0) {
        Timer(timeUntilPrayer, () {
          NotificationService.showPrayerNotification(prayer.name);
        });
      }
    }
  }

  void _scheduleQiyamNotification() {
    final now = DateTime.now();
    final tonight = DateTime(now.year, now.month, now.day, 2, 0); // 2:00 AM

    final target = tonight.isAfter(now)
        ? tonight
        : tonight.add(const Duration(days: 1)); // لليوم التالي

    Timer(target.difference(now), () {
      NotificationService.showNightPrayerReminder();
    });
  }

  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  int get prayedCount => prayers.where((p) => p.isPrayed).length;
  int get totalPrayers => prayers.length;

  Duration? get nextPrayerCountdown {
    final now = DateTime.now();
    final upcoming = prayers.firstWhere(
      (p) => p.time.isAfter(now),
      orElse: () =>
          PrayerModel(name: '', time: now.add(const Duration(days: 1))),
    );
    return upcoming.name.isEmpty ? null : upcoming.time.difference(now);
  }

  String? get nextPrayerName {
    final now = DateTime.now();
    final upcoming = prayers.firstWhere(
      (p) => p.time.isAfter(now),
      orElse: () => PrayerModel(name: '', time: now),
    );
    return upcoming.name.isEmpty ? null : upcoming.name;
  }
}
