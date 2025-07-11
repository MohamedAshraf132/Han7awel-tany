// radio_screen.dart
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  final player = AudioPlayer();

  final List<Map<String, String>> radios = [
    {
      'name': 'إذاعة القرآن الكريم - مصر',
      'url': 'https://stream.radiojar.com/8s5u5tpdtwzuv',
    },
    {
      'name': 'إذاعة القرآن الكريم - الكويت',
      'url': 'https://stream.radiojar.com/qrkkuv5kxtzuv',
    },
    {
      'name': 'إذاعة المجد للقرآن الكريم',
      'url': 'https://radio.liveislam.net:8443/quran-m',
    },
    {
      'name': 'إذاعة الشيخ عبد الباسط عبد الصمد',
      'url': 'https://server10.mp3quran.net:8443/basit-m',
    },
  ];

  String? currentUrl;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void toggleRadio(String url) async {
    if (currentUrl == url && player.playing) {
      await player.stop();
      setState(() => currentUrl = null);
    } else {
      try {
        await player.setUrl(url);
        await player.play();
        setState(() => currentUrl = url);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء تشغيل البث')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إذاعات قرآنية'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: radios.length,
        itemBuilder: (context, index) {
          final radio = radios[index];
          return ListTile(
            leading: const Icon(Icons.radio),
            title: Text(radio['name']!),
            trailing: IconButton(
              icon: Icon(
                currentUrl == radio['url'] && player.playing
                    ? Icons.pause_circle
                    : Icons.play_circle,
                color: Colors.teal,
                size: 30,
              ),
              onPressed: () => toggleRadio(radio['url']!),
            ),
          );
        },
      ),
    );
  }
}
