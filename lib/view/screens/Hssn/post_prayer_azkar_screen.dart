import 'dart:convert';
import 'package:flutter/material.dart';

class PostPrayerAzkarScreen extends StatefulWidget {
  const PostPrayerAzkarScreen({super.key});

  @override
  State<PostPrayerAzkarScreen> createState() => _PostPrayerAzkarScreenState();
}

class _PostPrayerAzkarScreenState extends State<PostPrayerAzkarScreen> {
  List<Map<String, dynamic>> _azkarList = [];

  Future<void> loadAzkar() async {
    final jsonString = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/PostPrayer_azkar.json');
    final jsonData = json.decode(jsonString);
    final List<dynamic> content = jsonData['content'];

    _azkarList = content.map<Map<String, dynamic>>((item) {
      return {...item, 'remaining': item['repeat']};
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
            'أذكار ما بعد الصلاة',
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
                            icon: const Icon(Icons.check),
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
