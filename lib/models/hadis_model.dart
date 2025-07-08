class Hadith {
  final String hadith;
  final String description;

  Hadith({required this.hadith, required this.description});

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      hadith: json['hadith'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
