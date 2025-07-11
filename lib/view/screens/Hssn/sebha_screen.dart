import 'package:flutter/material.dart';

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  State<SebhaScreen> createState() => _SebhaScreenState();
}

class _SebhaScreenState extends State<SebhaScreen> {
  int _counter = 0;
  int _currentIndex = 0;

  final List<String> _azkar = [
    'سبحان الله',
    'الحمد لله',
    'الله أكبر',
    'لا إله إلا الله',
    'أستغفر الله',
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _nextZekr() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _azkar.length;
      _counter = 0;
    });
  }

  void _previousZekr() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _azkar.length) % _azkar.length;
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'المسبحة الإلكترونية',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Text(
                _azkar[_currentIndex],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '$_counter',
                style: const TextStyle(fontSize: 60, color: Colors.black87),
              ),

              const SizedBox(height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _previousZekr,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 40,
                      ),
                    ),
                    child: const Text(
                      'اذكر',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _nextZekr,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
