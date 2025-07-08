import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:han7awel_tany/models/azkar_model.dart';

String removeDiacritics(String input) {
  final diacritics = RegExp(r'[\u064B-\u065F\u0610-\u061A\u06D6-\u06ED]');
  return input.replaceAll(diacritics, '');
}

Future<List<ZikrCategory>> loadAzkar() async {
  try {
    final String jsonString = await rootBundle.loadString('assets/hisn.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return jsonMap.entries.map((entry) {
      final rawTitle = entry.key;
      final cleanedTitle = removeDiacritics(rawTitle);
      final data = entry.value;
      return ZikrCategory.fromJson(cleanedTitle, data);
    }).toList();
  } catch (e) {
    print('Error loading azkar: $e');
    return [];
  }
}
