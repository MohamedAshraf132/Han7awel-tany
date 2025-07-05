import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:han7awel_tany/view/screens/splash_screen.dart'; // ✅ استيراد SplashScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Hive وفتح صندوق الصلوات
  await Hive.initFlutter();
  await Hive.openBox('prayers');

  runApp(const OverlaySupport.global(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تنظيم العبادات',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // ✅ نبدأ من Splash
      debugShowCheckedModeBanner: false,
    );
  }
}
