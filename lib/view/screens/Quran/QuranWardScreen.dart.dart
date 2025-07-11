// ملف: quran_ward_screen.dart
import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/Quran/QuranTrackingScreen.dart';
import 'package:provider/provider.dart';
import '../../../view_model/quran_vm.dart';

class QuranWardScreen extends StatefulWidget {
  const QuranWardScreen({super.key});

  @override
  State<QuranWardScreen> createState() => _QuranWardScreenState();
}

class _QuranWardScreenState extends State<QuranWardScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranWardViewModel>(context);

    return Directionality(
      textDirection: TextDirection.rtl, // 👈 لجعل المحتوى من اليمين لليسار
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ورد القرآن',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProgressSection(
                title: 'قراءة (${viewModel.readSurahName})',
                current: viewModel.currentReadPage,
                start: viewModel.startReadPage,
                target: viewModel.targetReadPage,
                onConfirm: () {
                  viewModel.confirmDailyProgress(read: true);
                  _checkIfFinished(
                    context,
                    viewModel.currentReadPage,
                    viewModel.targetReadPage,
                    '📘 قراءة',
                  );
                },
                onReset: () => viewModel.resetReadProgress(),
                dailyCount: viewModel.dailyReadPages,
                unit: 'صفحة',
              ),
              const SizedBox(height: 20),
              _buildProgressSection(
                title: 'حفظ (${viewModel.memorizeSurahName})',
                current: viewModel.currentMemorizedAyah,
                start: viewModel.startMemorizedAyah,
                target: viewModel.targetMemorizedAyah,
                onConfirm: () {
                  viewModel.confirmDailyProgress(memorize: true);
                  _checkIfFinished(
                    context,
                    viewModel.currentMemorizedAyah,
                    viewModel.targetMemorizedAyah,
                    'حفظ',
                  );
                },
                onReset: () => viewModel.resetMemorizeProgress(),
                dailyCount: viewModel.dailyMemorizeAyat,
                unit: 'آية',
              ),
              const SizedBox(height: 70),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400,
                  minimumSize: const Size(180, 50),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TrackingScreen()),
                  );
                  setState(() {});
                },
                icon: const Icon(Icons.track_changes, color: Colors.white),
                label: const Text(
                  'تتبع التقدم',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection({
    required String title,
    required int current,
    required int start,
    required int target,
    required VoidCallback onConfirm,
    required VoidCallback onReset,
    required int dailyCount,
    required String unit,
  }) {
    final int effectiveProgress = current - start;
    final int effectiveTotal = target - start;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: effectiveTotal <= 0
                  ? 0
                  : (effectiveProgress / effectiveTotal).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              color: Colors.teal,
            ),
            const SizedBox(height: 8),
            Text('المنجز: $effectiveProgress / $effectiveTotal'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                    ),
                    onPressed: onConfirm,
                    child: const Text(
                      'تم الإنجاز',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                    ),
                    onPressed: onReset,
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _checkIfFinished(
    BuildContext context,
    int current,
    int target,
    String sectionName,
  ) {
    if (current >= target) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لقد أنهيت ورد $sectionName بالكامل!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
