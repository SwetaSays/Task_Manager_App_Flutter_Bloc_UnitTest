import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';

import '../../domain/entities/task.dart';
import '../datasources/task_local_data_source.dart';
import 'package:collection/collection.dart';


class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  Future<List<Task>> _loadSorted() async {
    final models = await localDataSource.loadTasks();
    models.sort((a, b) => a.order.compareTo(b.order));
    return models;
  }

  @override
  Future<List<Task>> getTasks() async {
    return _loadSorted();
  }

  @override
  Future<void> addTask(Task task) async {
    final models = await localDataSource.loadTasks();
    final newModel = TaskModel.fromEntity(task);
    // set order to end
    final maxOrder = models.isEmpty ? -1 : models.map((e) => e.order).max;
    final modelWithOrder = TaskModel.fromMap({...newModel.toMap(), 'order': maxOrder + 1});
    models.add(modelWithOrder);
    await localDataSource.saveTasks(models);
  }

  @override
  Future<void> updateTask(Task task) async {
    final models = await localDataSource.loadTasks();
    final idx = models.indexWhere((m) => m.id == task.id);
    if (idx == -1) return;
    models[idx] = TaskModel.fromEntity(task);
    await localDataSource.saveTasks(models);
  }

  @override
  Future<void> deleteTask(String id) async {
    final models = await localDataSource.loadTasks();
    models.removeWhere((m) => m.id == id);
    await localDataSource.saveTasks(models);
  }

  @override
  Future<void> changeStatus(String id, int statusIndex) async {
    final models = await localDataSource.loadTasks();
    final idx = models.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    final m = models[idx];
    models[idx] = TaskModel.fromMap({...m.toMap(), 'status': statusIndex});
    await localDataSource.saveTasks(models);
  }

  @override
  Future<void> reorder(List<String> idsInNewOrder) async {
    final models = await localDataSource.loadTasks();
    final mapById = {for (var m in models) m.id: m};
    final reordered = <TaskModel>[];
    var order = 0;
    for (final id in idsInNewOrder) {
      final item = mapById[id];
      if (item != null) {
        reordered.add(TaskModel.fromMap({...item.toMap(), 'order': order}));
        order++;
      }
    }
    for (final m in models) {
      if (!idsInNewOrder.contains(m.id)) {
        reordered.add(TaskModel.fromMap({...m.toMap(), 'order': order}));
        order++;
      }
    }
    await localDataSource.saveTasks(reordered);
  }
}
