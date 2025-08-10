import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/repositories/task_repository_impl.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/update_task.dart';
import 'domain/usecases/change_status.dart';
import 'domain/usecases/reorder_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final localDataSource = TaskLocalDataSource(sharedPreferences: prefs);
  final repository = TaskRepositoryImpl(localDataSource: localDataSource);

  // Use cases
  final getTasks = GetTasks(repository);
  final addTask = AddTask(repository);
  final updateTask = UpdateTask(repository);
  final changeStatus = ChangeStatus(repository);
  final reorderTasks = ReorderTasks(repository);

  runApp(TaskManagerApp(
    getTasks: getTasks,
    addTask: addTask,
    updateTask: updateTask,
    changeStatus: changeStatus,
    reorderTasks: reorderTasks,
  ));
}
