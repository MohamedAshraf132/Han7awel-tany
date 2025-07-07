import 'package:hive/hive.dart';

part 'quran_ward_model.g.dart';

@HiveType(typeId: 1)
class QuranWard extends HiveObject {
  @HiveField(0)
  int dailyReadPages;

  @HiveField(1)
  int dailyMemorizeAyat;

  @HiveField(2)
  int currentReadPage;

  @HiveField(3)
  int currentMemorizedAyah;

  @HiveField(4)
  DateTime lastUpdated;

  @HiveField(5)
  String readSurahName;

  @HiveField(6)
  String memorizeSurahName;

  @HiveField(7)
  int startReadPage;

  @HiveField(8)
  int startMemorizedAyah;

  @HiveField(9)
  int targetReadPage;

  @HiveField(10)
  int targetMemorizedAyah;

  QuranWard({
    required this.dailyReadPages,
    required this.dailyMemorizeAyat,
    this.currentReadPage = 1,
    this.currentMemorizedAyah = 1,
    this.readSurahName = "البقرة",
    this.memorizeSurahName = "الناس",
    this.startReadPage = 1,
    this.startMemorizedAyah = 1,
    this.targetReadPage = 604,
    this.targetMemorizedAyah = 6236,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// ✅ التقدم النسبي حسب نقطة البداية والنهاية
  double get readProgress {
    int total = targetReadPage - startReadPage;
    if (total <= 0) return 0;
    int done = (currentReadPage - startReadPage).clamp(0, total);
    return done / total;
  }

  double get memorizeProgress {
    int total = targetMemorizedAyah - startMemorizedAyah;
    if (total <= 0) return 0;
    int done = (currentMemorizedAyah - startMemorizedAyah).clamp(0, total);
    return done / total;
  }

  /// ✅ التحديث مع التحقق من عدم تجاوز النهاية
  void updateProgress({bool read = false, bool memorize = false}) {
    if (read) {
      currentReadPage += dailyReadPages;
      if (currentReadPage > targetReadPage) {
        currentReadPage = targetReadPage;
      }
    }
    if (memorize) {
      currentMemorizedAyah += dailyMemorizeAyat;
      if (currentMemorizedAyah > targetMemorizedAyah) {
        currentMemorizedAyah = targetMemorizedAyah;
      }
    }
    lastUpdated = DateTime.now();
    save();
  }

  /// ✅ إعادة التعيين إلى نقطة البداية
  void resetRead() {
    currentReadPage = startReadPage;
    save();
  }

  void resetMemorize() {
    currentMemorizedAyah = startMemorizedAyah;
    save();
  }
}
