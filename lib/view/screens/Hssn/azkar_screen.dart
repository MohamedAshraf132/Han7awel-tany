import 'package:flutter/material.dart';
import 'package:han7awel_tany/core/services/load_azkar.dart';
import 'package:han7awel_tany/models/azkar_model.dart';
import 'package:han7awel_tany/view/screens/Hssn/zikr_details_screen.dart';

class AzkarScreen extends StatefulWidget {
  const AzkarScreen({super.key});

  @override
  State<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends State<AzkarScreen> {
  List<ZikrCategory> allCategories = [];
  List<ZikrCategory> filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAzkar().then((data) {
      setState(() {
        allCategories = data;
        filteredCategories = allCategories;
      });
    });

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      setState(() {
        filteredCategories = allCategories
            .where(
              (cat) => cat.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // ✅ أضفنا هذا السطر
      textDirection: TextDirection.rtl, // ✅ لجعل النصوص من اليمين
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الأذكار',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن الأذكار',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: filteredCategories.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCategories.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];
                        return ListTile(
                          title: Text(category.title),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AzkarDetailsScreen(category: category),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
