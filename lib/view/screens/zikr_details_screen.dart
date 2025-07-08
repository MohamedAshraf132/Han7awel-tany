import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:han7awel_tany/models/azkar_model.dart';

class AzkarDetailsScreen extends StatefulWidget {
  final ZikrCategory category;

  const AzkarDetailsScreen({super.key, required this.category});

  @override
  State<AzkarDetailsScreen> createState() => _AzkarDetailsScreenState();
}

class _AzkarDetailsScreenState extends State<AzkarDetailsScreen> {
  late List<int> counters;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    counters = List.filled(widget.category.adhkar.length, 0);
  }

  Future<void> _playSuccessSound() async {
    await _player.play(AssetSource('sounds/success.mp3'));
  }

  void _showCompletionNotification(String text) {
    showSimpleNotification(
      Text(
        "تم إنجاز الذكر ",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(text),
      background: Colors.green,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category.title,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.teal,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: widget.category.adhkar.length,
          itemBuilder: (context, index) {
            final zikr = widget.category.adhkar[index];
            final currentCount = counters[index];
            final maxCount = zikr.count;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(zikr.text, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    if (zikr.reference != null)
                      Text(
                        '${zikr.reference}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('التكرار: $currentCount / $maxCount'),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade400,
                          ),
                          onPressed: currentCount < maxCount
                              ? () {
                                  setState(() {
                                    counters[index]++;
                                  });

                                  if (counters[index] == maxCount) {
                                    _playSuccessSound();
                                    _showCompletionNotification(zikr.text);
                                  }
                                }
                              : null,
                          child: const Text(
                            'اذكر',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
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
