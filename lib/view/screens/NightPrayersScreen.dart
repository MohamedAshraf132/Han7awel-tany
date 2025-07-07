import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NightPrayersScreen extends StatefulWidget {
  const NightPrayersScreen({Key? key}) : super(key: key);

  @override
  State<NightPrayersScreen> createState() => _NightPrayersScreenState();
}

class _NightPrayersScreenState extends State<NightPrayersScreen> {
  late Box _box;

  int rakatsQiyam = 0;
  int rakatsTahajjud = 0;
  String qurqanReadText = "";

  String lastUpdateDate = "";

  @override
  void initState() {
    super.initState();
    _openBoxAndLoadData();
  }

  String _todayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  Future<void> _openBoxAndLoadData() async {
    _box = await Hive.openBox('nightPrayers');

    String savedDate = _box.get('lastUpdateDate', defaultValue: "");
    String today = _todayString();

    if (savedDate != today) {
      rakatsQiyam = 0;
      rakatsTahajjud = 0;
      qurqanReadText = "";
      await _saveData();
      await _box.put('lastUpdateDate', today);
    } else {
      rakatsQiyam = _box.get('rakatsQiyam', defaultValue: 0);
      rakatsTahajjud = _box.get('rakatsTahajjud', defaultValue: 0);
      qurqanReadText = _box.get('qurqanReadText', defaultValue: "");
    }

    setState(() {
      lastUpdateDate = today;
    });
  }

  Future<void> _saveData() async {
    await _box.put('rakatsQiyam', rakatsQiyam);
    await _box.put('rakatsTahajjud', rakatsTahajjud);
    await _box.put('qurqanReadText', qurqanReadText);
    await _box.put('lastUpdateDate', _todayString());
  }

  bool _didPrayToday(int rakats) => rakats > 0;

  Future<void> _showInputDialog({
    required String title,
    required int currentRakats,
    required Function(int rakats) onSubmit,
  }) async {
    final rakatsController = TextEditingController(
      text: currentRakats.toString(),
    );

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader, // نستخدم noHeader علشان نعمل رأس مخصص
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      title: 'عدد ركعات $title',
      customHeader: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.teal.shade700,
        child: Icon(
          Icons.brightness_3, // أيقونة الهلال (moon icon)
          size: 48,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: rakatsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'عدد الركعات',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
      ),
      btnCancelOnPress: () {},
      btnOkText: "حفظ",
      btnOkColor: Colors.teal.shade700,
      btnOkOnPress: () {
        final newRakats = int.tryParse(rakatsController.text) ?? currentRakats;
        onSubmit(newRakats);
        _saveData();
      },
    ).show();
  }

  Future<void> _showQuranTextInputDialog() async {
    final textController = TextEditingController(text: qurqanReadText);

    await AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      title: 'قراءة القرآن',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: textController,
          maxLines: 10,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
            hintText: 'اكتب نص الآيات أو السور التي قرأتها',
          ),
          keyboardType: TextInputType.multiline,
          autofocus: true,
        ),
      ),
      btnCancelOnPress: () {},
      btnOkText: "حفظ",
      btnOkColor: Colors.teal.shade700,
      btnOkOnPress: () {
        setState(() {
          qurqanReadText = textController.text;
        });
        _saveData();
      },
    ).show();
  }

  Widget _buildPrayerCard({
    required String title,
    required int rakats,
    required VoidCallback onEdit,
  }) {
    bool prayedToday = _didPrayToday(rakats);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      color: prayedToday ? Colors.teal.shade100 : Colors.white,
      shadowColor: Colors.teal.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal.shade800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'عدد الركعات: $rakats',
                    style: TextStyle(fontSize: 17, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'صليت اليوم؟ ${prayedToday ? "نعم" : "لا"}',
                    style: TextStyle(
                      color: prayedToday
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade300,
                foregroundColor: Colors.white, // هنا تحديد لون النص أبيض
                minimumSize: const Size(80, 38),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onEdit,
              child: const Text('تعديل', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      shadowColor: Colors.teal.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قراءة القرآن أثناء الصلاة',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal.shade800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  qurqanReadText.isEmpty
                      ? Text(
                          'لم تُكتب أي قراءة بعد',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          qurqanReadText,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade300,
                foregroundColor: Colors.white, // لون النص أبيض هنا أيضًا
                minimumSize: const Size(80, 38),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showQuranTextInputDialog,
              child: const Text('تعديل', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        elevation: 5,
        centerTitle: true,
        shadowColor: Colors.black,
        title: const Text(
          'صلوات قيام الليل والتهجد',
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
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            _buildPrayerCard(
              title: 'قيام الليل',
              rakats: rakatsQiyam,
              onEdit: () {
                _showInputDialog(
                  title: 'قيام الليل',
                  currentRakats: rakatsQiyam,
                  onSubmit: (rakats) {
                    setState(() {
                      rakatsQiyam = rakats;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _buildPrayerCard(
              title: 'التهجد',
              rakats: rakatsTahajjud,
              onEdit: () {
                _showInputDialog(
                  title: 'التهجد',
                  currentRakats: rakatsTahajjud,
                  onSubmit: (rakats) {
                    setState(() {
                      rakatsTahajjud = rakats;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            _buildQuranCard(),
          ],
        ),
      ),
    );
  }
}
