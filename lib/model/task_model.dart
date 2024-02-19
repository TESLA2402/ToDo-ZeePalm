import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String user_id;
  final String name;
  final String label;
  final String deadline;
  final String description;
  final bool isCompleted;
  final DateTime date;
  final DateTime time;

  Task(
      {required this.user_id,
      required this.name,
      required this.label,
      required this.deadline,
      required this.description,
      required this.isCompleted,
      required this.date,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'user_id': user_id,
      'label': label,
      'deadline': deadline,
      'description': description,
      'isCompleted': isCompleted,
      'date': date,
      'time': time,
    };
  }

  Task.fromMap(Map<String, dynamic> buyerMap)
      : name = buyerMap["name"],
        user_id = buyerMap["user_id"],
        label = buyerMap["label"],
        deadline = buyerMap["deadline"],
        description = buyerMap["description"],
        isCompleted = buyerMap["isCompleted"],
        date = buyerMap["date"],
        time = buyerMap["time"];

  Task.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : user_id = doc.data()!["user_id"],
        name = doc.data()!["name"],
        label = doc.data()!["label"],
        deadline = doc.data()!["deadline"],
        description = doc.data()!["description"],
        isCompleted = doc.data()!["isCompleted"],
        date = doc.data()!["date"],
        time = doc.data()!["time"];
}
