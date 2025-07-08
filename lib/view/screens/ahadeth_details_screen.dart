import 'package:flutter/material.dart';
import 'package:han7awel_tany/models/hadis_model.dart';

class AhadethDetailsScreen extends StatelessWidget {
  final Hadith hadith;

  const AhadethDetailsScreen({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الحديث'),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hadith.hadith, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'الشرح والفوائد:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(hadith.description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
