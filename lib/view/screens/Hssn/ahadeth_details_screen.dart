import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:han7awel_tany/models/hadis_model.dart';

class AhadethDetailsScreen extends StatefulWidget {
  final Hadith hadith;

  const AhadethDetailsScreen({super.key, required this.hadith});

  @override
  State<AhadethDetailsScreen> createState() => _AhadethDetailsScreenState();
}

class _AhadethDetailsScreenState extends State<AhadethDetailsScreen> {
  double fontSize = 18;

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ الحديث')));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفاصيل الحديث',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(widget.hadith.hadith),
              tooltip: 'نسخ الحديث',
            ),

            IconButton(
              icon: const Icon(Icons.format_size),
              onPressed: () {
                setState(() {
                  fontSize = fontSize == 18 ? 22 : 18;
                });
              },
              tooltip: 'تكبير/تصغير الخط',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.hadith.hadith,
                  style: TextStyle(fontSize: fontSize),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  'الشرح والفوائد:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.hadith.description,
                  style: TextStyle(fontSize: fontSize - 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
