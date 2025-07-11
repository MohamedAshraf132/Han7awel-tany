import 'dart:convert';
import 'package:flutter/material.dart';

class MorningAzkarScreen extends StatefulWidget {
  const MorningAzkarScreen({super.key});

  @override
  State<MorningAzkarScreen> createState() => _MorningAzkarScreenState();
}

class _MorningAzkarScreenState extends State<MorningAzkarScreen> {
  List<Map<String, dynamic>> _azkarList = [];

  Future<void> loadAzkar() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/azkar_sbaah.json');
    final jsonData = json.decode(jsonString);
    final List<dynamic> content = jsonData['content'];

    // نضيف عداد داخلي لكل ذكر
    _azkarList = content.map<Map<String, dynamic>>((item) {
      return {
        ...item,
        'remaining': item['repeat'], // عداد خاص لكل ذكر
      };
    }).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAzkar();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'أذكار الصباح',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: _azkarList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _azkarList.length,
                itemBuilder: (context, index) {
                  final item = _azkarList[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['zekr'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.repeat,
                                size: 20,
                                color: Colors.teal,
                              ),
                              const SizedBox(width: 6),
                              Text("المتبقي: ${item['remaining']}"),
                            ],
                          ),
                          if (item['bless'] != null &&
                              item['bless'].toString().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item['bless'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: item['remaining'] > 0
                                ? () {
                                    setState(() {
                                      item['remaining']--;
                                    });
                                  }
                                : null,
                            label: const Text('اذكر'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
