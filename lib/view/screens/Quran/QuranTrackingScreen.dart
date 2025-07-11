import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/quran_vm.dart';

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
  final TextEditingController readPageTo = TextEditingController();
  final TextEditingController memorizeAyahFrom = TextEditingController();
  final TextEditingController memorizeAyahTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<QuranWardViewModel>(context);

    selectedReadSurah ??= surahNames.contains(viewModel.readSurahName)
        ? viewModel.readSurahName
        : surahNames.first;
    selectedMemorizeSurah ??= surahNames.contains(viewModel.memorizeSurahName)
        ? viewModel.memorizeSurahName
        : surahNames.first;

    readPageFrom.text = viewModel.startReadPage.toString();
    readPageTo.text = viewModel.targetReadPage.toString();
    memorizeAyahFrom.text = viewModel.startMemorizedAyah.toString();
    memorizeAyahTo.text = viewModel.targetMemorizedAyah.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        elevation: 5,
        centerTitle: true,
        shadowColor: Colors.black,
        title: const Text(
          'تتبع التقدم',
          style: TextStyle(fontSize: 22, letterSpacing: 1, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'رجوع',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTrackingSection(
            title: 'القراءة',
            surahValue: selectedReadSurah!,
            onSurahChanged: (val) => setState(() => selectedReadSurah = val),
            surahList: surahNames,
            fromController: readPageFrom,
            toController: readPageTo,
            fromLabel: 'من الصفحة',
            toLabel: 'إلى الصفحة',
            onSave: () {
              final fromPage = int.tryParse(readPageFrom.text) ?? 1;
              final toPage = int.tryParse(readPageTo.text) ?? fromPage;

              viewModel.updateDailyGoals(
                readPages: viewModel.dailyReadPages,
                memorizeAyat: viewModel.dailyMemorizeAyat,
                readSurah: selectedReadSurah!,
                memorizeSurah: viewModel.memorizeSurahName,
                startRead: fromPage,
                targetRead: toPage,
              );

              viewModel.updateReadPage(fromPage);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم تحديث ورد القراءة')),
              );
            },
          ),
          const SizedBox(height: 30),
          _buildTrackingSection(
            title: 'الحفظ',
            surahValue: selectedMemorizeSurah!,
            onSurahChanged: (val) =>
                setState(() => selectedMemorizeSurah = val),
            surahList: surahNames,
            fromController: memorizeAyahFrom,
            toController: memorizeAyahTo,
            fromLabel: 'من الآية',
            toLabel: 'إلى الآية',
            onSave: () {
              final fromAyah = int.tryParse(memorizeAyahFrom.text) ?? 1;
              final toAyah = int.tryParse(memorizeAyahTo.text) ?? fromAyah;

              viewModel.updateDailyGoals(
                readPages: viewModel.dailyReadPages,
                memorizeAyat: viewModel.dailyMemorizeAyat,
                readSurah: viewModel.readSurahName,
                memorizeSurah: selectedMemorizeSurah!,
                startAyah: fromAyah,
                targetAyah: toAyah,
              );

              viewModel.updateMemorizedAyah(fromAyah);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ تم تحديث ورد الحفظ')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingSection({
    required String title,
    required String surahValue,
    required ValueChanged<String?> onSurahChanged,
    required List<String> surahList,
    required TextEditingController fromController,
    required TextEditingController toController,
    required String fromLabel,
    required String toLabel,
    required VoidCallback onSave,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: surahValue,
              items: surahList
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: onSurahChanged,
              decoration: const InputDecoration(labelText: 'اختر السورة'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fromController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: fromLabel),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: toController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: toLabel),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onSave,
              child: const Text(
                'حفظ',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
