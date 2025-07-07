// ملف: prayers_screen.dart
import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/NightPrayersScreen.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../view_model/prayers_vm.dart';

class PrayersScreen extends StatefulWidget {
  const PrayersScreen({super.key});

  @override
  State<PrayersScreen> createState() => _PrayersScreenState();
}

class _PrayersScreenState extends State<PrayersScreen> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose(); // تنظيف مورد الصوت عند إغلاق الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrayersViewModel(),
      child: Consumer<PrayersViewModel>(
        builder: (context, vm, _) {
          final double progress = vm.totalPrayers == 0
              ? 0
              : vm.prayedCount / vm.totalPrayers;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: const Text(
                'إِنَّ الصّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
              elevation: 4,
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: 60,
                  ), // مساحة للويدجيت الثابت
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // العداد
                      Text(
                        '${vm.prayedCount} / ${vm.totalPrayers} صلوات مؤداة',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // شريط التقدم
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.teal.shade100,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.teal,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // كرت قيام الليل والتهجد للانتقال للصفحة الخاصة
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Card(
                          color: Colors.teal.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.nightlight_round,
                              color: Colors.teal,
                            ),
                            title: const Text(
                              'قيام الليل والتهجد',
                              style: TextStyle(fontSize: 18),
                            ),

                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const NightPrayersScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // قائمة الصلوات
                      Expanded(
                        child: ListView.builder(
                          itemCount: vm.prayers.length,
                          itemBuilder: (context, index) {
                            final prayer = vm.prayers[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                elevation: 2,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  splashColor: Colors.teal.shade50,
                                  onTap: () {},
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    leading: _buildPrayerIcon(
                                      prayer.name,
                                      prayer.isPrayed,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          prayer.name,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        if (prayer.isPrayed)
                                          const Padding(
                                            padding: EdgeInsets.only(right: 6),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                              size: 18,
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      vm.formatTime(prayer.time),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: prayer.isPrayed
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () =>
                                                vm.unmarkAsPrayed(index),
                                            child: const Text('إلغاء'),
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              vm.markAsPrayed(index);

                                              // تشغيل صوت
                                              await _player.play(
                                                AssetSource(
                                                  'sounds/success.mp3',
                                                ),
                                              );

                                              // رسالة تشجيعية عشوائية
                                              final messages = [
                                                'زادك الله حرصًا وهمة! ',
                                                'ثبتك الله على طاعته ',
                                                'صلاة مقبولة بإذن الله ',
                                                'نور الله قلبك بالصلاة ',
                                                'أحسنت! بارك الله فيك ',
                                                'اللهم اجعلها شافعة لك يوم القيامة ',
                                              ];

                                              final randomMessage =
                                                  (messages..shuffle()).first;

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    randomMessage,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  backgroundColor:
                                                      Colors.teal.shade600,
                                                  duration: const Duration(
                                                    seconds: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('صليت'),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ويدجيت الصلاة القادمة الثابتة في الأعلى
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade600,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Consumer<PrayersViewModel>(
                      builder: (context, vm, _) {
                        if (vm.nextPrayerName == null ||
                            vm.nextPrayerCountdown == null) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          'الصلاة القادمة: ${vm.nextPrayerName} بعد ${_formatDuration(vm.nextPrayerCountdown!)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (hours > 0) {
      return '$hours س ${minutes.toString().padLeft(2, '0')} د';
    } else {
      return '${minutes.toString().padLeft(2, '0')} دقيقة';
    }
  }

  Widget _buildPrayerIcon(String name, bool isPrayed) {
    IconData icon;
    switch (name) {
      case 'الفجر':
        icon = Icons.wb_twilight;
        break;
      case 'الظهر':
        icon = Icons.sunny;
        break;
      case 'العصر':
        icon = Icons.wb_sunny;
        break;
      case 'المغرب':
        icon = Icons.brightness_4;
        break;
      case 'العشاء':
        icon = Icons.nights_stay;
        break;
      default:
        icon = Icons.access_time;
    }

    return Icon(
      icon,
      color: isPrayed ? Colors.green : Colors.teal.shade400,
      size: 28,
    );
  }
}
