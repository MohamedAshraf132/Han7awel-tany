// core/services/load_ahadeth.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:han7awel_tany/models/hadis_model.dart';

Future<List<Hadith>> loadAhadeth() async {
  final String jsonString = await rootBundle.loadString(
    'assets/40-hadith-nawawi.json',
  );
  final List<dynamic> jsonList = json.decode(jsonString);

  return jsonList.map((json) => Hadith.fromJson(json)).toList();
}
