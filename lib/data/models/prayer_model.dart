class PrayerModel {
  final String name;
  final DateTime time;
  bool isPrayed;

  PrayerModel({required this.name, required this.time, this.isPrayed = false});
}
