import 'package:flutter/material.dart';
import 'package:han7awel_tany/core/services/permission_service.dart';
import 'package:han7awel_tany/view/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2)); // وقت العرض
    await PermissionService.requestAllPermissions(context);

    // بعد إتمام الصلاحيات، انتقل للصفحة الرئيسية
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // لون الخلفية
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt, // أيقونة القوة ⚡
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'هنحاول تاني',
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
