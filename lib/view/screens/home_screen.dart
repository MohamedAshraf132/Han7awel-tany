import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/prayers_screens.dart';
import 'package:han7awel_tany/view_model/quran_vm.dart';
import 'package:han7awel_tany/view_model/settings_vm.dart';
import 'package:han7awel_tany/view_model/tasks_vm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PrayersScreen(),
    QuranScreen(),
    TasksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Color(0xFF26A69A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 40,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Center(
                child: Icon(Icons.bolt, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'الإعدادات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
