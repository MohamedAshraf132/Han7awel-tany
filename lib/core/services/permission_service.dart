import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// ✅ تطلب جميع الصلاحيات الضرورية
  static Future<void> requestAllPermissions(BuildContext context) async {
    final locationStatus = await Permission.location.request();
    final notificationStatus = await Permission.notification.request();

    if (locationStatus.isDenied || notificationStatus.isDenied) {
      _showDeniedDialog(context);
    }
  }

  /// ⛔ تنبيه لو تم الرفض
  static void _showDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الصلاحيات مطلوبة'),
        content: const Text(
          'الرجاء السماح بصلاحيات الموقع والتنبيهات ليعمل التطبيق بشكل صحيح.',
        ),
        actions: [
          TextButton(
            child: const Text('فتح الإعدادات'),
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
