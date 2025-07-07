import 'package:flutter/material.dart';
import 'package:han7awel_tany/core/services/notification_service.dart';
import 'package:hive/hive.dart';
import '../models/quran_ward_model.dart';

class QuranWardViewModel extends ChangeNotifier {
  static const String _boxName = 'quran_ward_box';

  late QuranWard ward;
  final Box<QuranWard> _box = Hive.box<QuranWard>(_boxName);
  void updateReadPage(int page) {
    ward.currentReadPage = page;
    ward.save();
    notifyListeners();
  }

  void updateMemorizedAyah(int ayah) {
    ward.currentMemorizedAyah = ayah;
    ward.save();
    notifyListeners();
  }

  QuranWardViewModel() {
    _loadWard();
  }

  /// تحميل البيانات من Hive أو إنشاء قيمة افتراضية
  void _loadWard() {
    QuranWard? stored = _box.get('ward');
    if (stored != null) {
      ward = stored;
    } else {
      ward = QuranWard(
        dailyReadPages: 2,
        dailyMemorizeAyat: 3,
        readSurahName: 'البقرة',
        memorizeSurahName: 'الملك',
      );
      _box.put('ward', ward);
    }
    notifyListeners();
  }

  /// تعديل الورد اليومي
  void updateDailyGoals({
    required int readPages,
    required int memorizeAyat,
    required String readSurah,
    required String memorizeSurah,
  }) {
    ward.dailyReadPages = readPages;
    ward.dailyMemorizeAyat = memorizeAyat;
    ward.readSurahName = readSurah;
    ward.memorizeSurahName = memorizeSurah;
    ward.lastUpdated = DateTime.now();
    ward.save();
    notifyListeners();
  }

  /// تأكيد إتمام الورد اليومي + إشعار
  void confirmDailyProgress({bool read = false, bool memorize = false}) {
    ward.updateProgress(read: read, memorize: memorize);
    NotificationService.showQuranSuccessNotification(); // ✅ إشعار نجاح الإنجاز
    notifyListeners();
  }

  /// إرسال إشعار تذكير بورد اليوم
  void showDailyReminder() {
    NotificationService.showDailyQuranReminder();
  }

  // ✅ Getters
  double get readProgress => ward.readProgress;
  double get memorizeProgress => ward.memorizeProgress;
  DateTime get lastUpdated => ward.lastUpdated;
  int get dailyReadPages => ward.dailyReadPages;
  int get dailyMemorizeAyat => ward.dailyMemorizeAyat;
  int get currentReadPage => ward.currentReadPage;
  int get currentMemorizedAyah => ward.currentMemorizedAyah;
  String get readSurahName => ward.readSurahName;
  String get memorizeSurahName => ward.memorizeSurahName;

  // ✅ Setters للتعديل الفردي إذا لزم الأمر
  void updateReadSurah(String name) {
    ward.readSurahName = name;
    ward.save();
    notifyListeners();
  }

  void updateMemorizeSurah(String name) {
    ward.memorizeSurahName = name;
    ward.save();
    notifyListeners();
  }
}
