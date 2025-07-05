import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/prayers_vm.dart';

class PrayersScreen extends StatelessWidget {
  const PrayersScreen({super.key});

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

              centerTitle: true,
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE0F2F1), Color(0xFFFFFFFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // ✅ العداد
                  Text(
                    '${vm.prayedCount} / ${vm.totalPrayers} صلوات مؤداة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ✅ الشريط
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

                  // ⏰ الصلاة القادمة
                  if (vm.nextPrayerName != null)
                    Text(
                      'الصلاة القادمة: ${vm.nextPrayerName} بعد ${_formatDuration(vm.nextPrayerCountdown!)}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.teal.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ✅ قائمة الصلوات
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
                                title: Text(
                                  prayer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        onPressed: () => vm.markAsPrayed(index),
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
        icon = Icons.wb_twighlight;
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
