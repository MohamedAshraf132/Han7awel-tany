import 'package:flutter/material.dart';
import 'package:han7awel_tany/view/screens/tasks_details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/course_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late Box _courseBox;

  @override
  void initState() {
    super.initState();
    _courseBox = Hive.box('courses');
  }

  void _addCourse() {
    if (_courseController.text.trim().isEmpty) return;
    final course = Course(
      name: _courseController.text.trim(),
      points: [],
      notes: '',
    );
    final List existing = _courseBox.get('data', defaultValue: []);
    existing.add(course.toMap());
    _courseBox.put('data', existing);
    _courseController.clear();
    setState(() {});
  }

  void _addPoint(int index, String point) {
    final List data = _courseBox.get('data', defaultValue: []);
    final course = Course.fromMap(Map<String, dynamic>.from(data[index]));
    course.points.add(TaskPoint(text: point));
    data[index] = course.toMap();
    _courseBox.put('data', data);
    setState(() {});
  }

  void _togglePoint(int courseIndex, int pointIndex) {
    final List data = _courseBox.get('data', defaultValue: []);
    final course = Course.fromMap(Map<String, dynamic>.from(data[courseIndex]));
    course.points[pointIndex].done = !course.points[pointIndex].done;
    data[courseIndex] = course.toMap();
    _courseBox.put('data', data);
    setState(() {});
  }

  void _openCourseDetails(Course course, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailsScreen(
          course: course,
          index: index,
          onSave: _saveCourseDetails,
        ),
      ),
    );
  }

  void _saveCourseDetails(Course updatedCourse, int index) {
    final List data = _courseBox.get('data', defaultValue: []);
    data[index] = updatedCourse.toMap();
    _courseBox.put('data', data);
    setState(() {});
  }

  void _addGeneralTask() {
    final text = _taskController.text.trim();
    if (text.isEmpty) return;
    final List tasks = _courseBox.get('general_tasks', defaultValue: []);
    tasks.add(text);
    _courseBox.put('general_tasks', tasks);
    _taskController.clear();
    setState(() {});
  }

  void _removeGeneralTask(int index) {
    final List tasks = _courseBox.get('general_tasks', defaultValue: []);
    tasks.removeAt(index);
    _courseBox.put('general_tasks', tasks);
    setState(() {});
  }

  void _saveGeneralNote() {
    _courseBox.put('general_note', _noteController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final List rawCourses = _courseBox.get('data', defaultValue: []);
    final List<Course> allCourses = [];
    for (var e in rawCourses) {
      if (e is Map || e is Map<dynamic, dynamic>) {
        try {
          allCourses.add(Course.fromMap(Map<String, dynamic>.from(e)));
        } catch (_) {}
      }
    }

    final List<String> generalTasks = List<String>.from(
      _courseBox.get('general_tasks', defaultValue: []),
    );
    _noteController.text = _courseBox.get('general_note', defaultValue: '');

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'المهام والدورات',
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('📌 مهام عامة'),
            _buildStyledTextField(
              controller: _taskController,
              hint: 'أضف مهمة خارجية',
              icon: Icons.add,
              onPressed: _addGeneralTask,
            ),
            const SizedBox(height: 8),
            ...List.generate(
              generalTasks.length,
              (index) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(generalTasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeGeneralTask(index),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('📝 ملاحظات عامة'),
            TextField(
              controller: _noteController,
              maxLines: 3,
              onChanged: (_) => _saveGeneralNote(),
              decoration: InputDecoration(
                hintText: 'أكتب ملاحظة هنا...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('📚 الدورات'),
            _buildStyledTextField(
              controller: _courseController,
              hint: 'اسم الكورس أو الملاحظة العامة',
              icon: Icons.add_circle,
              onPressed: _addCourse,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              allCourses.length,
              (index) => GestureDetector(
                onTap: () => _openCourseDetails(allCourses[index], index),
                child: _buildCourseCard(allCourses[index], index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: IconButton(
          icon: Icon(icon, color: Colors.teal),
          onPressed: onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 18)),
    );
  }

  Widget _buildCourseCard(Course course, int courseIndex) {
    final TextEditingController pointController = TextEditingController();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    course.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pointController,
              decoration: InputDecoration(
                hintText: 'أضف نقطة جديدة في هذا الكورس',
                filled: true,
                fillColor: Colors.grey.shade100,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    if (pointController.text.trim().isNotEmpty) {
                      _addPoint(courseIndex, pointController.text.trim());
                      pointController.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              course.points.length,
              (pointIndex) => CheckboxListTile(
                title: Text(course.points[pointIndex].text),
                value: course.points[pointIndex].done,
                onChanged: (_) => _togglePoint(courseIndex, pointIndex),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
