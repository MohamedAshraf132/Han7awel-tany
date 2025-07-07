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

  QuranWard({
    required this.dailyReadPages,
    required this.dailyMemorizeAyat,
    this.currentReadPage = 1,
    this.currentMemorizedAyah = 1,
    this.readSurahName = "البقرة",
    this.memorizeSurahName = "الناس",
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  double get readProgress => currentReadPage / 604;
  double get memorizeProgress => currentMemorizedAyah / 6236;

  void updateProgress({bool read = false, bool memorize = false}) {
    if (read) {
      currentReadPage += dailyReadPages;
      if (currentReadPage > 604) currentReadPage = 604;
    }
    if (memorize) {
      currentMemorizedAyah += dailyMemorizeAyat;
      if (currentMemorizedAyah > 6236) currentMemorizedAyah = 6236;
    }
    lastUpdated = DateTime.now();
    save();
  }
}
