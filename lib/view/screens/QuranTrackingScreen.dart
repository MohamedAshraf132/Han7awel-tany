import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/quran_vm.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final List<String> surahNames = [
    'الفاتحة',
    'البقرة',
    'آل عمران',
    'النساء',
    'المائدة',
    'الأنعام',
    'الأعراف',
    'الأنفال',
    'التوبة',
    'يونس',
    'هود',
    'يوسف',
    'الرعد',
    'إبراهيم',
    'الحجر',
    'النحل',
    'الإسراء',
    'الكهف',
    'مريم',
    'طه',
    'الأنبياء',
    'الحج',
    'المؤمنون',
    'النور',
    'الفرقان',
    'الشعراء',
    'النمل',
    'القصص',
    'العنكبوت',
    'الروم',
    'لقمان',
    'السجدة',
    'الأحزاب',
    'سبأ',
    'فاطر',
    'يس',
    'الصافات',
    'ص',
    'الزمر',
    'غافر',
    'فصلت',
    'الشورى',
    'الزخرف',
    'الدخان',
    'الجاثية',
    'الأحقاف',
    'محمد',
    'الفتح',
    'الحجرات',
    'ق',
    'الذاريات',
    'الطور',
    'النجم',
    'القمر',
    'الرحمن',
    'الواقعة',
    'الحديد',
    'المجادلة',
    'الحشر',
    'الممتحنة',
    'الصف',
    'الجمعة',
    'المنافقون',
    'التغابن',
    'الطلاق',
    'التحريم',
    'الملك',
    'القلم',
    'الحاقة',
    'المعارج',
    'نوح',
    'الجن',
    'المزمل',
    'المدثر',
    'القيامة',
    'الإنسان',
    'المرسلات',
    'النبأ',
    'النازعات',
    'عبس',
    'التكوير',
    'الانفطار',
    'المطففين',
    'الانشقاق',
    'البروج',
    'الطارق',
    'الأعلى',
    'الغاشية',
    'الفجر',
    'البلد',
    'الشمس',
    'الليل',
    'الضحى',
    'الشرح',
    'التين',
    'العلق',
    'القدر',
    'البينة',
    'الزلزلة',
    'العاديات',
    'القارعة',
    'التكاثر',
    'العصر',
    'الهمزة',
    'الفيل',
    'قريش',
    'الماعون',
    'الكوثر',
    'الكافرون',
    'النصر',
    'المسد',
    'الإخلاص',
    'الفلق',
    'الناس',
  ];

  String? selectedReadSurah;
  String? selectedMemorizeSurah;
  final TextEditingController readPageFrom = TextEditingController();
  final TextEditingController memorizeAyahFrom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranWardViewModel>(context);

    selectedReadSurah ??= surahNames.contains(viewModel.readSurahName)
        ? viewModel.readSurahName
        : surahNames.first;

    selectedMemorizeSurah ??= surahNames.contains(viewModel.memorizeSurahName)
        ? viewModel.memorizeSurahName
        : surahNames.first;

    readPageFrom.text = viewModel.currentReadPage.toString();
    memorizeAyahFrom.text = viewModel.currentMemorizedAyah.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع التقدم'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            title: 'القراءة',
            surahValue: selectedReadSurah!,
            onSurahChanged: (val) => setState(() => selectedReadSurah = val),
            surahList: surahNames,
            numberController: readPageFrom,
            numberLabel: 'من الصفحة',
            onSave: () {
              final page = int.tryParse(readPageFrom.text) ?? 1;
              viewModel.updateReadPage(page);
              viewModel.updateReadSurah(selectedReadSurah!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث ورد القراءة ✅')),
              );
            },
          ),
          const SizedBox(height: 30),
          _buildSection(
            title: 'الحفظ',
            surahValue: selectedMemorizeSurah!,
            onSurahChanged: (val) =>
                setState(() => selectedMemorizeSurah = val),
            surahList: surahNames,
            numberController: memorizeAyahFrom,
            numberLabel: 'من الآية',
            onSave: () {
              final ayah = int.tryParse(memorizeAyahFrom.text) ?? 1;
              viewModel.updateMemorizedAyah(ayah);
              viewModel.updateMemorizeSurah(selectedMemorizeSurah!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث ورد الحفظ ✅')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String surahValue,
    required ValueChanged<String?> onSurahChanged,
    required List<String> surahList,
    required TextEditingController numberController,
    required String numberLabel,
    required VoidCallback onSave,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: surahValue,
              items: surahList
                  .map(
                    (name) => DropdownMenuItem(value: name, child: Text(name)),
                  )
                  .toList(),
              onChanged: onSurahChanged,
              decoration: const InputDecoration(labelText: 'اختر السورة'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: numberLabel),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: onSave, child: const Text('💾 حفظ')),
          ],
        ),
      ),
    );
  }
}
