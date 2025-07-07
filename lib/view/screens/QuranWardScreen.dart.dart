import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/QuranTrackingScreen.dart';
import 'package:provider/provider.dart';
import '../../view_model/quran_vm.dart';

class QuranWardScreen extends StatefulWidget {
  const QuranWardScreen({super.key});

  @override
  State<QuranWardScreen> createState() => _QuranWardScreenState();
}

class _QuranWardScreenState extends State<QuranWardScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranWardViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ورد القرآن'), centerTitle: true),
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
                  '📖 حفظ',
                );
              },
              onReset: () => viewModel.resetMemorizeProgress(),
              dailyCount: viewModel.dailyMemorizeAyat,
              unit: 'آية',
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackingScreen()),
                );
                setState(() {});
              },
              icon: const Icon(Icons.track_changes),
              label: const Text('تتبع التقدم'),
            ),
          ],
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
            Text(
              '$title ($unit يومي: $dailyCount)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: onConfirm,
                    child: const Text('تم الإنجاز'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: onReset,
                    child: const Text('إلغاء'),
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
          content: Text('🎉 لقد أنهيت ورد $sectionName بالكامل!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
