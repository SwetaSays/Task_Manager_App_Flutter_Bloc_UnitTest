
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';

class TaskLocalDataSource {
  final SharedPreferences sharedPreferences;
  final _uuid = const Uuid();

  TaskLocalDataSource({required this.sharedPreferences});

  Future<List<TaskModel>> loadTasks() async {
    final jsonString = sharedPreferences.getString(kStorageKeyTasks);
    if (jsonString == null) {
      final seeded = _seedTasks();
      await saveTasks(seeded);
      return seeded;
    }
    try {
      return TaskModel.decodeList(jsonString);
    } catch (_) {
      final seeded = _seedTasks();
      await saveTasks(seeded);
      return seeded;
    }
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final jsonString = TaskModel.encodeList(tasks);
    await sharedPreferences.setString(kStorageKeyTasks, jsonString);
  }

  List<TaskModel> _seedTasks() {
    final now = DateTime.now();
    return [
      TaskModel(
        id: _uuid.v4(),
        title: 'Buy groceries',
        description: 'Milk, Eggs, Bread, Coffee',
        status: TaskStatus.todo,
        dueDate: now.add(const Duration(days: 1)),
        order: 0,
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Prepare presentation',
        description: 'Slides for Monday meeting',
        status: TaskStatus.inProgress,
        dueDate: now.add(const Duration(days: 2)),
        order: 1,
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Workout',
        description: '45 mins cardio',
        status: TaskStatus.done,
        dueDate: now.subtract(const Duration(days: 1)),
        order: 2,
      ),
    ];
  }
}
