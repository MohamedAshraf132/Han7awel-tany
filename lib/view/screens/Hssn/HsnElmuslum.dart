import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/Hssn/evening_azkar_screen.dart';
import 'package:han7awel_tany/view/screens/Hssn/morning_azkar_screen.dart';
import 'package:han7awel_tany/view/screens/Hssn/post_prayer_azkar_screen.dart';
import 'package:han7awel_tany/view/screens/Hssn/sebha_screen.dart';
import 'package:han7awel_tany/view/screens/Hssn/radio_screen.dart'; // إذا كنت أضفت صفحة الإذاعة
import 'azkar_screen.dart';
import 'ahadeth_screen.dart';

class Hsnelmuslum extends StatelessWidget {
  const Hsnelmuslum({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الأذكار والأحاديث',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('أذكار الصباح'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MorningAzkarScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.nights_stay),
              title: const Text('أذكار المساء'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EveningAzkarScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.mosque),
              title: const Text('أذكار ما بعد الصلاة'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PostPrayerAzkarScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('حصن المسلم'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AzkarScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text('الأحاديث الأربعون النووية'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AhadethScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('المسبحة الإلكترونية'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SebhaScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.radio),
              title: const Text('إذاعات قرآنية'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RadioScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
