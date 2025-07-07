import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart'; // ✅ أضف هذا
import 'package:han7awel_tany/view/screens/splash_screen.dart';
import 'view_model/quran_vm.dart'; // ✅ أضف هذا
import 'models/quran_ward_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(QuranWardAdapter());
  await Hive.openBox('prayers');
  await Hive.openBox<QuranWard>('quran_ward_box');

  await initializeDateFormatting('ar', null);

  runApp(
    OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => QuranWardViewModel(),
          ), // ✅ أضف هذا
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تنظيم العبادات',
      theme: ThemeData(
        fontFamily: 'Playpen_Sans_Arabic',
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
