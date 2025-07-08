class ZikrItem {
  final String text;
  final int count;
  final String? reference;

  ZikrItem({required this.text, required this.count, this.reference});

  factory ZikrItem.fromJson(Map<String, dynamic> json) {
    return ZikrItem(
      text: json['Text'] ?? '',
      count: json['Count'] ?? 1,
      reference: json['Reference'],
    );
  }
}

class ZikrCategory {
  final String title;
  final String? audio;
  final List<ZikrItem> adhkar;

  ZikrCategory({required this.title, this.audio, required this.adhkar});

  factory ZikrCategory.fromJson(String title, Map<String, dynamic> json) {
    final List<dynamic> adhkarJson = json['Adhkar'] ?? [];
    return ZikrCategory(
      title: title,
      audio: json['Audio'],
      adhkar: adhkarJson.map((e) => ZikrItem.fromJson(e)).toList(),
    );
  }
}
