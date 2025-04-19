import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

/// All the [CRUD] operation method for Hive_DB
class HiveDataStore {
  ///Box Name -String
  static const boxName = 'taskBox';

  ///Our Current Box with all the saved data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  ///Add New Task  To Box
  Future<void> addTask({required Task task}) async {
    await box.put(task.id, task);
  }

  ///Show Task
  Future<Task?> getTask({required String id}) async {
    return box.get(id);
  }

  ///Update Task
  Future<void> updateTask({required Task task}) async {
    await task.save();
  }

  ///Delete Task
  Future<void> deleteTask({required Task task}) async {
    await task.delete();
  }

  ///Listen to Box Changes

  ValueListenable<Box<Task>> listenToTask() => box.listenable();
}
