import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/course_model.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;
  final int index;
  final void Function(Course updatedCourse, int index) onSave;

  const CourseDetailsScreen({
    super.key,
    required this.course,
    required this.index,
    required this.onSave,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late TextEditingController _notesController;
  final TextEditingController _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.course.notes);
  }

  void _addLink() {
    final text = _linkController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.course.links.add(text);
      _linkController.clear();
    });
    widget.onSave(widget.course, widget.index);
  }

  void _saveNotes() {
    widget.course.notes = _notesController.text.trim();
    widget.onSave(widget.course, widget.index);
  }

  void _removeLink(int i) {
    setState(() => widget.course.links.removeAt(i));
    widget.onSave(widget.course, widget.index);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // ✅ هذا السطر مهم جدًا
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('الرابط غير صالح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final int total = widget.course.points.length;
    final int done = widget.course.points.where((p) => p.done).length;
    final double progress = total == 0 ? 0 : done / total;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ' ${widget.course.name}',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          backgroundColor: Colors.teal,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                'ملاحظات:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _notesController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'أضف ملاحظاتك هنا'),
                onChanged: (_) => _saveNotes(),
              ),
              const SizedBox(height: 20),
              const Text(
                'روابط مفيدة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  hintText: 'أضف رابط جديد',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addLink,
                  ),
                ),
              ),
              ...List.generate(
                widget.course.links.length,
                (i) => ListTile(
                  title: Text(widget.course.links[i]),
                  leading: IconButton(
                    icon: const Icon(Icons.open_in_new, color: Colors.teal),
                    onPressed: () => _openUrl(widget.course.links[i]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeLink(i),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'مؤشر الإنجاز:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                color: Colors.teal,
              ),
              const SizedBox(height: 6),
              Text('${(progress * 100).toStringAsFixed(0)}٪ مكتمل'),
            ],
          ),
        ),
      ),
    );
  }
}
