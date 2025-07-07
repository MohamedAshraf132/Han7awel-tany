import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quran_ward_model.dart';
import '../core/services/notification_service.dart';

class QuranWardViewModel extends ChangeNotifier {
  static const String _boxName = 'quran_ward_box';

  late QuranWard ward;
  final Box<QuranWard> _box = Hive.box<QuranWard>(_boxName);

  QuranWardViewModel() {
    _loadWard();
  }

  void _loadWard() {
    final stored = _box.get('ward');
    if (stored != null) {
      ward = stored;
    } else {
      ward = QuranWard(
        dailyReadPages: 2,
        dailyMemorizeAyat: 3,
        readSurahName: 'البقرة',
        memorizeSurahName: 'الملك',
        startReadPage: 1,
        startMemorizedAyah: 1,
        targetReadPage: 604,
        targetMemorizedAyah: 6236,
      );
      _box.put('ward', ward);
    }
    notifyListeners();
  }

  void updateDailyGoals({
    required int readPages,
    required int memorizeAyat,
    required String readSurah,
    required String memorizeSurah,
    int? startRead,
    int? startAyah,
    int? targetRead,
    int? targetAyah,
  }) {
    ward.dailyReadPages = readPages;
    ward.dailyMemorizeAyat = memorizeAyat;
    ward.readSurahName = readSurah;
    ward.memorizeSurahName = memorizeSurah;

    if (startRead != null) ward.startReadPage = startRead;
    if (startAyah != null) ward.startMemorizedAyah = startAyah;
    if (targetRead != null) ward.targetReadPage = targetRead;
    if (targetAyah != null) ward.targetMemorizedAyah = targetAyah;

    ward.lastUpdated = DateTime.now();
    ward.save();
    notifyListeners();
  }

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

  void resetReadProgress() {
    ward.currentReadPage = ward.startReadPage;
    ward.save();
    notifyListeners();
  }

  void resetMemorizeProgress() {
    ward.currentMemorizedAyah = ward.startMemorizedAyah;
    ward.save();
    notifyListeners();
  }

  void confirmDailyProgress({bool read = false, bool memorize = false}) {
    int readBefore = ward.currentReadPage;
    int memorizeBefore = ward.currentMemorizedAyah;

    ward.updateProgress(read: read, memorize: memorize);

    int readDone = ward.currentReadPage - readBefore;
    int memorizeDone = ward.currentMemorizedAyah - memorizeBefore;

    if (read) {
      NotificationService.showQuranSuccessNotification(
        message: '📖 تم إنجاز $readDone صفحة من ${ward.readSurahName}',
      );
    }
    if (memorize) {
      NotificationService.showQuranSuccessNotification(
        message: '🧠 تم إنجاز $memorizeDone آية من ${ward.memorizeSurahName}',
      );
    }

    notifyListeners();
  }

  void showDailyReminder() {
    NotificationService.showDailyQuranReminder();
  }

  // Getters
  double get readProgress => ward.readProgress;
  double get memorizeProgress => ward.memorizeProgress;

  int get dailyReadPages => ward.dailyReadPages;
  int get dailyMemorizeAyat => ward.dailyMemorizeAyat;

  int get currentReadPage => ward.currentReadPage;
  int get currentMemorizedAyah => ward.currentMemorizedAyah;

  int get startReadPage => ward.startReadPage;
  int get startMemorizedAyah => ward.startMemorizedAyah;

  int get targetReadPage => ward.targetReadPage;
  int get targetMemorizedAyah => ward.targetMemorizedAyah;

  String get readSurahName => ward.readSurahName;
  String get memorizeSurahName => ward.memorizeSurahName;

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

  void updateStartAndTarget({
    int? startRead,
    int? targetRead,
    int? startMemorize,
    int? targetMemorize,
  }) {
    if (startRead != null) ward.startReadPage = startRead;
    if (targetRead != null) ward.targetReadPage = targetRead;
    if (startMemorize != null) ward.startMemorizedAyah = startMemorize;
    if (targetMemorize != null) ward.targetMemorizedAyah = targetMemorize;
    ward.save();
    notifyListeners();
  }
}
