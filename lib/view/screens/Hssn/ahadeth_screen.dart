import 'package:flutter/material.dart';
import 'package:han7awel_tany/core/services/load_ahadeth.dart';
import 'package:han7awel_tany/models/hadis_model.dart';
import 'ahadeth_details_screen.dart';

class AhadethScreen extends StatefulWidget {
  const AhadethScreen({super.key});

  @override
  State<AhadethScreen> createState() => _AhadethScreenState();
}

class _AhadethScreenState extends State<AhadethScreen> {
  List<Hadith> allAhadeth = [];
  List<Hadith> filteredAhadeth = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAhadeth().then((data) {
      setState(() {
        allAhadeth = data;
        filteredAhadeth = data;
      });
    });

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        filteredAhadeth = allAhadeth
            .where(
              (hadith) =>
                  hadith.hadith.toLowerCase().contains(query) ||
                  hadith.description.toLowerCase().contains(query),
            )
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الأحاديث الأربعون النووية',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن حديث أو شرح',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: filteredAhadeth.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAhadeth.length,
                      itemBuilder: (context, index) {
                        final hadith = filteredAhadeth[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              hadith.hadith.split('\n').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AhadethDetailsScreen(hadith: hadith),
                                ),
                              );
                            },
                          ),
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
