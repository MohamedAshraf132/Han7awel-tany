import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/QuranTrackingScreen.dart';
import 'package:provider/provider.dart';
import '../../view_model/quran_vm.dart';

class QuranWardScreen extends StatelessWidget {
  const QuranWardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranWardViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ورد القرآن'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // عرض الورد الخاص بالقراءة
            _buildProgressSection(
              title: 'قراءة (${viewModel.readSurahName})',
              current: viewModel.currentReadPage,
              total: 604,
              progress: viewModel.readProgress,
              onConfirm: () => viewModel.confirmDailyProgress(read: true),
              dailyCount: viewModel.dailyReadPages,
              unit: 'صفحة',
            ),
            const SizedBox(height: 20),

            // عرض الورد الخاص بالحفظ
            _buildProgressSection(
              title: 'حفظ (${viewModel.memorizeSurahName})',
              current: viewModel.currentMemorizedAyah,
              total: 6236,
              progress: viewModel.memorizeProgress,
              onConfirm: () => viewModel.confirmDailyProgress(memorize: true),
              dailyCount: viewModel.dailyMemorizeAyat,
              unit: 'آية',
            ),
            const SizedBox(height: 30),

            // زر تعديل الورد اليومي
            ElevatedButton.icon(
              onPressed: () => _showEditDialog(context, viewModel),
              icon: const Icon(Icons.edit),
              label: const Text('تعديل الورد اليومي'),
            ),
            const SizedBox(height: 10),

            // زر تتبع التقدم
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrackingScreen()),
                );
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
    required int total,
    required double progress,
    required VoidCallback onConfirm,
    required int dailyCount,
    required String unit,
  }) {
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
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text('المنجز: $current / $total'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onConfirm,
              child: const Text('✅ تم الإنجاز اليوم'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, QuranWardViewModel viewModel) {
    final readController = TextEditingController(
      text: viewModel.dailyReadPages.toString(),
    );
    final memorizeController = TextEditingController(
      text: viewModel.dailyMemorizeAyat.toString(),
    );
    final readSurahController = TextEditingController(
      text: viewModel.readSurahName,
    );
    final memorizeSurahController = TextEditingController(
      text: viewModel.memorizeSurahName,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل الورد اليومي'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: readController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'صفحات القراءة يومياً',
                ),
              ),
              TextField(
                controller: readSurahController,
                decoration: const InputDecoration(labelText: 'سورة القراءة'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: memorizeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'آيات الحفظ يومياً',
                ),
              ),
              TextField(
                controller: memorizeSurahController,
                decoration: const InputDecoration(labelText: 'سورة الحفظ'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final read = int.tryParse(readController.text) ?? 1;
              final memorize = int.tryParse(memorizeController.text) ?? 1;
              final readSurah = readSurahController.text.trim().isEmpty
                  ? 'غير محددة'
                  : readSurahController.text;
              final memorizeSurah = memorizeSurahController.text.trim().isEmpty
                  ? 'غير محددة'
                  : memorizeSurahController.text;

              viewModel.updateDailyGoals(
                readPages: read,
                memorizeAyat: memorize,
                readSurah: readSurah,
                memorizeSurah: memorizeSurah,
              );
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}
