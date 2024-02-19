// ignore_for_file: body_might_complete_normally_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeepalmtodo/model/task_model.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  addTask(Task employeeData) async {
    await _db.collection("Task").add(employeeData.toMap());
  }

  Future<List<Task>> retrieveTask(userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Task").where('user_id', isEqualTo: userId).get();
    return snapshot.docs
        .map((docSnapshot) => Task.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<void> deleteTask(String userId) async {
    FirebaseFirestore.instance.collection("Task").doc(userId).delete();
  }

  Future<void> updateTask(String userId, Task updatedTask) async {
    FirebaseFirestore.instance.collection('Task').doc(userId).update({
      'name': updatedTask.name,
      'label': updatedTask.label,
      'deadline': updatedTask.deadline,
      'description': updatedTask.description,
      'isCompleted': updatedTask.isCompleted,
      'date': updatedTask.date,
      'time': updatedTask.time,
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }
}
