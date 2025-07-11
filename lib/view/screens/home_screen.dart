import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/Hssn/HsnElmuslum.dart';
import 'package:han7awel_tany/view/screens/Prayers/prayers_screens.dart';
import 'package:han7awel_tany/view/screens/TasksScreen.dart';

import 'Quran/QuranWardScreen.dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PrayersScreen(),
    QuranWardScreen(),
    TasksScreen(),
    Hsnelmuslum(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey.shade500,
            selectedFontSize: 13,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'الصلوات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'القرآن',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: 'الأعمال'),
              BottomNavigationBarItem(icon: Icon(Icons.book), label: 'حصن'),
            ],
          ),
        ),
      ),
    );
  }
}
