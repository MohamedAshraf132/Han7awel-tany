class TaskPoint {
  String text;
  bool done;

  TaskPoint({required this.text, this.done = false});

  Map<String, dynamic> toMap() => {'text': text, 'done': done};

  factory TaskPoint.fromMap(Map<String, dynamic> map) =>
      TaskPoint(text: map['text'], done: map['done']);
}

class Course {
  String name;
  List<TaskPoint> points;
  String notes;
  List<String> links;

  Course({
    required this.name,
    List<TaskPoint>? points,
    this.notes = '',
    List<String>? links,
  }) : points = points ?? [],
       links = links ?? [];

  Map<String, dynamic> toMap() => {
    'name': name,
    'points': points.map((e) => e.toMap()).toList(),
    'notes': notes,
    'links': links,
  };

  factory Course.fromMap(Map<String, dynamic> map) => Course(
    name: map['name'],
    notes: map['notes'] ?? '',
    links: List<String>.from(map['links'] ?? []),
    points: (map['points'] as List)
        .map((e) => TaskPoint.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );
}
