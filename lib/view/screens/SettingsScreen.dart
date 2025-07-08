import 'package:flutter/material.dart';
import 'azkar_screen.dart';
import 'ahadeth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // ✅ لجعل الاتجاه من اليمين
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
              title: const Text('الأذكار'),
              subtitle: const Text('أذكار الصباح، المساء، الصلاة...'),
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
          ],
        ),
      ),
    );
  }
}
