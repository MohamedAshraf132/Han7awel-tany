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

  @override
  void initState() {
    super.initState();
    loadAhadeth().then((data) {
      setState(() {
        allAhadeth = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأحاديث الأربعون النووية'),
          backgroundColor: Colors.teal,
        ),
        body: allAhadeth.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: allAhadeth.length,
                itemBuilder: (context, index) {
                  final hadith = allAhadeth[index];
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
    );
  }
}
