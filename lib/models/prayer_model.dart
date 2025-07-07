class PrayerModel {
  String name;
  DateTime time;
  bool isPrayed;
  int prayedRakats; // عدد الركعات التي صليتها فعلاً
  int totalRakats; // عدد الركعات المطلوب أداؤها

  PrayerModel({
    required this.name,
    required this.time,
    this.isPrayed = false,
    this.prayedRakats = 0,
    this.totalRakats = 2, // مثلا 2 ركعات كافضل قيمة افتراضية
  });
}
